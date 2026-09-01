#!/usr/bin/env ruby
# frozen_string_literal: true

# Re-checks every URL currently marked class="dead-link" against the Wayback
# Availability API. Exists because the original bulk lookup (wayback_lookup.rb,
# 5 concurrent workers) produced at least one confirmed false negative -- a
# "no snapshot" result for a URL that demonstrably has one -- most likely
# because hammering the API with concurrency caused it to return a 200 with
# an empty body rather than a real error we'd retry on. This run is
# deliberately single-threaded, slow, and retries even on a "200 but empty"
# response (not just on error statuses).
#
# It also hard-stops the whole run on the first real 429: pushing through
# retries during an actual rate-limit episode risks compounding it into a
# long bad stretch (and more false negatives), so instead we bail immediately,
# save what we have, and let it be resumed later. Output is incremental JSONL
# (one line per checked URL, flushed immediately) and resumable, same pattern
# as wayback_lookup.rb, so a stop -- deliberate or forced -- costs nothing.
#
# Usage: ruby script/reverify_dead_links.rb

require "json"
require "net/http"
require "cgi"

ROOT = File.expand_path("..", __dir__)
URLS_FILE = File.join(ROOT, "tmp/currently_marked_dead_urls.txt")
OUT_JSONL = File.join(ROOT, "tmp/reverify_results.jsonl")

MAX_ATTEMPTS = 4
REQUEST_TIMEOUT = 12

class RateLimited < StandardError; end

def with_hard_timeout(seconds)
  result = nil
  t = Thread.new { result = yield }
  finished = t.join(seconds)
  t.kill unless finished
  finished ? result : nil
rescue StandardError
  nil
end

# Returns [snapshot_or_nil, attempts_used]. Raises RateLimited on an actual 429.
def check(url)
  api = URI("https://archive.org/wayback/available?url=#{CGI.escape(url)}")

  MAX_ATTEMPTS.times do |attempt|
    res = with_hard_timeout(REQUEST_TIMEOUT) do
      Net::HTTP.start(api.host, api.port, use_ssl: true, open_timeout: REQUEST_TIMEOUT, read_timeout: REQUEST_TIMEOUT) do |http|
        http.request(Net::HTTP::Get.new(api))
      end
    end

    raise RateLimited, url if res.is_a?(Net::HTTPTooManyRequests)

    if res.is_a?(Net::HTTPSuccess)
      data = JSON.parse(res.body) rescue nil
      snap = data && data.dig("archived_snapshots", "closest")
      return [snap, attempt + 1] if snap && snap["available"]
      # 200 but empty: this is exactly the failure mode we're guarding against.
      # Don't trust it on the first try -- retry with a real pause before
      # concluding "genuinely no snapshot."
    end

    sleep(4 * (attempt + 1)) # 4s, 8s, 12s, 16s
  end

  [nil, MAX_ATTEMPTS]
end

all_urls = File.readlines(URLS_FILE).map(&:strip).reject(&:empty?)

already_done = {}
if File.exist?(OUT_JSONL)
  File.foreach(OUT_JSONL) do |line|
    next if line.strip.empty?

    rec = JSON.parse(line)
    already_done[rec["url"]] = true
  end
end

todo = all_urls.reject { |u| already_done[u] }
puts "#{all_urls.size} total, #{already_done.size} already re-verified, #{todo.size} to go..."

out = File.open(OUT_JSONL, "a")
out.sync = true

found_so_far = 0
stopped_early = false

todo.each_with_index do |url, i|
  begin
    snap, attempts = check(url)
  rescue RateLimited
    puts "\n\nHit an actual 429 (rate limited) on #{url}. Stopping here rather than pushing through it."
    puts "Progress is saved -- just re-run this script later to pick up where it left off."
    stopped_early = true
    break
  end

  found_so_far += 1 if snap
  print "\r#{i + 1}/#{todo.size} (snapshots found so far: #{found_so_far})   "

  out.puts JSON.generate({ url: url, snapshot_found: !!snap, wayback_url: snap && snap["url"], attempts: attempts })
  sleep 2.0 # slow and polite -- no concurrency, generous spacing
end

out.close

unless stopped_early
  puts "\n\nDone re-verifying."
end

all_results = File.readlines(OUT_JSONL).map { |l| JSON.parse(l) }
found = all_results.select { |r| r["snapshot_found"] }
puts "#{found.size} of #{all_results.size} checked links actually HAVE a snapshot (false negatives from the original sweep)."
if found.any?
  puts "\nFalse negatives (need to be un-marked and reconsidered):"
  found.each { |r| puts "  #{r["url"]} -> #{r["wayback_url"]}" }
end
