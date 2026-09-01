#!/usr/bin/env ruby
# frozen_string_literal: true

# Corrects the false negatives found by reverify_dead_links.rb: links that
# were wrongly marked class="dead-link" (the original bulk Wayback sweep
# said "no snapshot" when one actually exists). Un-marks them and repoints
# the href to the confirmed-working Wayback snapshot, keeping the original
# link text untouched.
#
# Usage: ruby script/fix_false_negatives.rb

require "json"

ROOT = File.expand_path("..", __dir__)
POSTS_DIR = File.join(ROOT, "_posts")
IN_JSON = File.join(ROOT, "tmp/false_negatives.json")

false_negatives = JSON.parse(File.read(IN_JSON))
puts "#{false_negatives.size} confirmed false negatives to fix"

posts = {}
Dir.glob(File.join(POSTS_DIR, "*.{md,markdown}")).each { |p| posts[p] = File.read(p, encoding: "utf-8") }

fixed = 0
not_found = []

false_negatives.each do |fn|
  url = fn["url"]
  wayback_url = fn["wayback_url"]
  esc = Regexp.escape(url)

  matched_any = false
  posts.each do |path, content|
    re = /<a class="dead-link" title="[^"]*" (?:([^>]*?)\s+)?href="#{esc}"([^>]*)>(.*?)<\/a><span class="dead-link-mark">†<\/span>/m
    next unless content.match?(re)

    matched_any = true
    new_content = content.gsub(re) do
      pre, post, text = $1, $2, $3
      fixed += 1
      %(<a #{pre ? "#{pre} " : ""}href="#{wayback_url}"#{post}>#{text}</a>)
    end
    posts[path] = new_content
  end

  not_found << url unless matched_any
end

posts.each { |path, content| File.write(path, content) }

puts "Fixed #{fixed} occurrences"
if not_found.any?
  puts "Could not find #{not_found.size} of them (already fixed, or pattern mismatch):"
  not_found.each { |u| puts "  #{u}" }
end
