#!/usr/bin/env ruby
# frozen_string_literal: true

# Re-checks every external link that failed with 403/429/401/406 in the
# original audit (tmp/link_audit.csv) using a normal browser User-Agent
# instead of html-proofer's identifying one. A lot of sites block obvious
# bots/scrapers but serve a normal request just fine -- this separates
# "actually dead" from "our checker got blocked" without needing a manual
# browser visit for all ~228 of them. Does not touch web.archive.org (see
# reverify_dead_links.rb for that, separately).
#
# Usage: ruby script/recheck_maybe_alive.rb

require "csv"
require "json"
require "net/http"

ROOT = File.expand_path("..", __dir__)
IN_CSV = File.join(ROOT, "tmp/link_audit.csv")
OUT_JSONL = File.join(ROOT, "tmp/recheck_maybe_alive.jsonl")

REQUEST_TIMEOUT = 12
UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36"

def with_hard_timeout(seconds)
  result = nil
  t = Thread.new { result = yield }
  finished = t.join(seconds)
  t.kill unless finished
  finished ? result : nil
rescue StandardError
  nil
end

# Follows up to 5 redirects by hand (simpler to reason about than trusting a
# library default here). Returns final Net::HTTP response, or nil on failure.
def fetch(url, limit = 5)
  return nil if limit <= 0

  uri = URI(url)
  return nil unless uri.host

  res = with_hard_timeout(REQUEST_TIMEOUT) do
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: REQUEST_TIMEOUT, read_timeout: REQUEST_TIMEOUT) do |http|
      req = Net::HTTP::Get.new(uri)
      req["User-Agent"] = UA
      req["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
      http.request(req)
    end
  end

  return nil unless res

  if res.is_a?(Net::HTTPRedirection) && res["location"]
    next_url = URI.join(url, res["location"]).to_s rescue nil
    return next_url ? fetch(next_url, limit - 1) : res
  end

  res
rescue StandardError
  nil
end

rows = CSV.read(IN_CSV, headers: true).select do |r|
  r["check_name"] == "Links > External" && %w[403 429 401 406].include?(r["status"])
end
urls = rows.map { |r| r["detail"][/External link (\S+) failed/, 1] }.compact.uniq

already_done = {}
if File.exist?(OUT_JSONL)
  File.foreach(OUT_JSONL) { |l| already_done[JSON.parse(l)["url"]] = true unless l.strip.empty? }
end
todo = urls.reject { |u| already_done[u] }

puts "#{urls.size} total, #{already_done.size} already checked, #{todo.size} to go..."

out = File.open(OUT_JSONL, "a")
out.sync = true

now_alive = 0
todo.each_with_index do |url, i|
  res = fetch(url)
  code = res&.code
  alive = res.is_a?(Net::HTTPSuccess)
  now_alive += 1 if alive
  print "\r#{i + 1}/#{todo.size} (now looking alive: #{now_alive})   "
  out.puts JSON.generate({ url: url, now_alive: alive, status: code })
  sleep 1.0
end

out.close
puts "\nDone. #{now_alive} of #{todo.size} newly-checked links respond fine with a normal browser UA."
