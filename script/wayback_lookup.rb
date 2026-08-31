#!/usr/bin/env ruby
# frozen_string_literal: true

# For every "Links > External" failure in tmp/link_audit.csv, pull the link's
# text/context out of the actual rendered post (so a human reviewer knows
# what it was about) and check the Wayback Machine for a snapshot near the
# post's publish date. Writes tmp/wayback_review.jsonl incrementally (one
# JSON object per line, flushed per row) and is resumable: rerun the same
# command and it skips URLs already recorded. See build_link_review_page.rb
# for turning the JSONL into a browsable HTML page.
#
# Usage: bundle exec ruby script/wayback_lookup.rb
# (run script/audit_links.rb first so tmp/link_audit.csv is current)

require "csv"
require "json"
require "net/http"
require "nokogiri"
require "cgi"

ROOT = File.expand_path("..", __dir__)
SITE_ARCHIVES = File.join(ROOT, "_site/archives")
IN_CSV = File.join(ROOT, "tmp/link_audit.csv")
OUT_JSONL = File.join(ROOT, "tmp/wayback_review.jsonl")

MAX_RETRIES = 2
REQUEST_TIMEOUT = 10 # seconds, via Net::HTTP's own open/read timeouts

# Ruby's Timeout.timeout is known to sometimes fail to interrupt a blocked
# native OpenSSL read (the classic footgun). Running the request in its own
# thread and killing *that thread* on a join timeout is a more reliable way
# to bound a stalled TLS connection than wrapping the call in Timeout.timeout.
def with_hard_timeout(seconds)
  result = nil
  t = Thread.new { result = yield }
  finished = t.join(seconds)
  unless finished
    t.kill
    return nil
  end
  result
rescue StandardError
  nil
end

# Returns [snapshot_or_nil, lookup_failed_boolean].
def wayback_lookup(url, timestamp)
  api = URI("https://archive.org/wayback/available?url=#{CGI.escape(url)}&timestamp=#{timestamp}")

  (MAX_RETRIES + 1).times do |attempt|
    res = with_hard_timeout(REQUEST_TIMEOUT) do
      Net::HTTP.start(api.host, api.port, use_ssl: true, open_timeout: REQUEST_TIMEOUT, read_timeout: REQUEST_TIMEOUT) do |http|
        http.request(Net::HTTP::Get.new(api))
      end
    end

    if res.is_a?(Net::HTTPSuccess)
      data = JSON.parse(res.body)
      snap = data.dig("archived_snapshots", "closest")
      return [(snap && snap["available"]) ? snap : nil, false]
    end

    warn "  [retry #{attempt + 1}] #{url} -> #{res ? res.code : "timeout/error"}"
    sleep(2 * (attempt + 1)) # 2s, 4s backoff
  end

  [nil, true] # exhausted retries -- unknown, not "confirmed no snapshot"
end

def extract_context(html_path, url)
  return {} unless File.exist?(html_path)

  doc = Nokogiri::HTML(File.read(html_path, encoding: "utf-8"))
  title = doc.at_css("title")&.text&.sub(/\s*-\s*chester's blog\z/, "")

  link = doc.css("a").find { |a| a["href"] == url }
  link_text = link&.text&.strip
  context = link&.ancestors("p, li, div")&.first&.text&.strip
  context = context[0, 220] if context

  { post_title: title, link_text: link_text, context: context }
end

rows = CSV.read(IN_CSV, headers: true).select { |r| r["check_name"] == "Links > External" }
rows = rows.first(ENV["LIMIT"].to_i) if ENV["LIMIT"]

already_done = {}
if File.exist?(OUT_JSONL)
  File.foreach(OUT_JSONL) do |line|
    next if line.strip.empty?

    rec = JSON.parse(line)
    already_done[rec["url"]] = true unless rec["wayback_lookup_failed"] # only skip confirmed lookups, retry failures
  end
end

todo = rows.reject { |row| already_done[row["detail"][/External link (\S+) failed/, 1]] }
puts "#{rows.size} external URLs total, #{already_done.size} already looked up, #{todo.size} to go..."

WORKERS = (ENV["WORKERS"] || 5).to_i

out = File.open(OUT_JSONL, "a")
out.sync = true
out_mutex = Mutex.new
done_count = 0
count_mutex = Mutex.new

queue = Queue.new
todo.each { |row| queue << row }
WORKERS.times { queue << nil } # one poison pill per worker

def process(row)
  url = row["detail"][/External link (\S+) failed/, 1]
  html_path = File.join(SITE_ARCHIVES, row["example_file"])

  # permalinks are /archives/:year/:month/:title/ -- the year/month prefix is
  # always present and reliable, unlike the post's own <time> element (which
  # a separate, pre-existing template bug leaves empty on many pages)
  year, month = row["example_file"].split("/").first(2)
  post_date = (year && month) ? "#{year}-#{month}" : nil
  timestamp = (year && month) ? "#{year}#{month}15" : Time.now.strftime("%Y%m%d")

  ctx = extract_context(html_path, url)
  wb, failed = wayback_lookup(url, timestamp)

  {
    url: url,
    status: row["status"],
    note: row["likely_false_positive_note"],
    post_file: row["example_file"],
    post_title: ctx[:post_title],
    post_date: post_date,
    link_text: ctx[:link_text],
    context: ctx[:context],
    occurrences: row["occurrences"].to_i,
    other_files: row["all_files"],
    wayback_url: wb ? wb["url"] : nil,
    wayback_timestamp: wb ? wb["timestamp"] : nil,
    wayback_lookup_failed: failed,
  }
end

threads = WORKERS.times.map do
  Thread.new do
    while (row = queue.pop)
      record = process(row)
      out_mutex.synchronize { out.puts JSON.generate(record) }
      count_mutex.synchronize do
        done_count += 1
        print "\r#{done_count}/#{todo.size}   "
      end
      sleep 1.0 # be polite to archive.org, per worker
    end
  end
end
threads.each(&:join)

out.close
puts "\nDone. Run again to retry any rows where wayback_lookup_failed was true (rare stalls/rate-limits)."
