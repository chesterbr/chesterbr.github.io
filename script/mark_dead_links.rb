#!/usr/bin/env ruby
# frozen_string_literal: true

# For every external URL confirmed dead (404/410/connection-error) with no
# Wayback Machine snapshot available, mark it up in every post that links to
# it: <a class="dead-link" title="..."> + a trailing <span class="dead-link-mark">
# marker, so the link is still there (provenance) but visibly flagged, in a
# way that survives RSS/plain-text contexts too. Does NOT touch links that
# are merely possibly-false-positive (403/429/etc) or have a Wayback snapshot
# -- those need human judgment, not a mechanical sweep.
#
# Usage:
#   ruby script/mark_dead_links.rb            # dry run, reports what it would do
#   DRY_RUN=0 ruby script/mark_dead_links.rb   # actually writes the files

require "json"

ROOT = File.expand_path("..", __dir__)
POSTS_DIR = File.join(ROOT, "_posts")
DATA_JSONL = File.join(ROOT, "tmp/wayback_review.jsonl")
DRY_RUN = ENV["DRY_RUN"] != "0"

TITLES = { "en" => "this link died", "pt-BR" => "este link morreu" }
MARK = "†"

def post_lang(content)
  content[/^lang:\s*(\S+)/, 1] || "en"
end

by_url = {}
File.foreach(DATA_JSONL) do |line|
  next if line.strip.empty?

  rec = JSON.parse(line)
  by_url[rec["url"]] = rec
end

# web.archive.org URLs in the "confirmed dead, no snapshot" bucket are a
# known false-positive class: this network can't reach web.archive.org at
# all, so the checker reports them as dead regardless of whether the actual
# snapshot is fine (confirmed still working, by hand, in a real browser).
# Excluded at the source so a re-run never re-marks them.
targets = by_url.values.select do |r|
  !r["wayback_url"] && %w[404 410 0].include?(r["status"]) && !r["url"].include?("web.archive.org")
end
target_urls = targets.map { |r| r["url"] }
puts "#{target_urls.size} confirmed-dead URLs with no snapshot to mark."

posts = {}
Dir.glob(File.join(POSTS_DIR, "*.{md,markdown}")).each { |p| posts[p] = File.read(p, encoding: "utf-8") }

fixed = 0        # occurrences successfully transformed
touched_files = {}
unmatched = []    # [url, reasons per file where url text appears but couldn't be transformed]

target_urls.each do |url|
  # old posts markdown-escape underscores in URLs (\_); html-proofer's parser
  # normalizes that to %5C_ when it reports the href, so the raw source and
  # the reported URL don't literally match -- try the de-escaped form too
  raw_url = url.include?("%5C") ? url.gsub("%5C", "\\") : url
  esc = Regexp.escape(raw_url)
  found_anywhere = false

  posts.each do |path, content|
    next unless content.include?(raw_url)

    found_anywhere = true
    lang = post_lang(content)
    title = TITLES[lang] || TITLES["en"]
    changed = false

    # 1. raw HTML <a ...href="URL"...>TEXT</a> (idempotent: skip if already marked, so a
    # re-run -- e.g. after a future re-check -- doesn't double-apply on top of itself)
    html_re = /<a\s+([^>]*?)href="[ \t]*#{esc}"([^>]*)>(.*?)<\/a>/m
    if content.match?(html_re)
      content.gsub!(html_re) do
        pre, post, text = $1, $2, $3
        if pre.include?("dead-link") || post.include?("dead-link")
          "<a #{pre}href=\"#{raw_url}\"#{post}>#{text}</a>"
        else
          changed = true
          %(<a class="dead-link" title="#{title}" #{pre}href="#{raw_url}"#{post}>#{text}</a><span class="dead-link-mark">#{MARK}</span>)
        end
      end
    end

    # 2. inline markdown [text](URL)
    inline_re = /\[([^\]]+)\]\(#{esc}\)/
    if content.match?(inline_re)
      content.gsub!(inline_re) do
        text = $1
        changed = true
        %(<a class="dead-link" title="#{title}" href="#{raw_url}">#{text}</a><span class="dead-link-mark">#{MARK}</span>)
      end
    end

    # 3. reference-style [text][ref] with a [ref]: URL definition (optionally
    # followed by a "title" as in [ref]: URL "Title text")
    content.scan(/^[ \t]*\[([^\]]+)\]:[ \t]*#{esc}[ \t]*(?:\S.*)?$/).flatten.uniq.each do |ref|
      use_re = /\[([^\]]+)\]\[#{Regexp.escape(ref)}\]/
      next unless content.match?(use_re)

      content.gsub!(use_re) do
        text = $1
        changed = true
        %(<a class="dead-link" title="#{title}" href="#{raw_url}">#{text}</a><span class="dead-link-mark">#{MARK}</span>)
      end

      # drop the definition line only if nothing still uses that ref name
      unless content.match?(/\[[^\]]+\]\[#{Regexp.escape(ref)}\]/)
        content.sub!(/^[ \t]*\[#{Regexp.escape(ref)}\]:[ \t]*#{esc}[ \t]*(?:\S.*)?\n?/, "")
      end
    end

    # 4. bare autolink <URL> (link text is the URL itself)
    autolink_re = /<#{esc}>/
    if content.match?(autolink_re)
      content.gsub!(autolink_re) do
        changed = true
        %(<a class="dead-link" title="#{title}" href="#{raw_url}">#{raw_url}</a><span class="dead-link-mark">#{MARK}</span>)
      end
    end

    if changed
      posts[path] = content
      touched_files[path] = true
      fixed += 1
    else
      unmatched << [url, path]
    end
  end

  unmatched << [url, nil] unless found_anywhere
end

puts "Occurrences transformed: #{fixed}"
puts "Files touched: #{touched_files.size}"
if unmatched.any?
  puts "\nCould not auto-transform #{unmatched.size} url/file pair(s) -- needs a manual look (see tmp/mark_dead_links_unmatched.txt)"
  File.open(File.join(ROOT, "tmp/mark_dead_links_unmatched.txt"), "w") do |f|
    unmatched.each { |url, path| f.puts "#{path ? File.basename(path) : "(not found in any post -- may only be in a reader comment, or not a real link)"}: #{url}" }
  end
end

if DRY_RUN
  puts "\nDry run -- no files written. Re-run with DRY_RUN=0 to apply."
else
  touched_files.each_key { |path| File.write(path, posts[path]) }
  puts "\nWrote changes to #{touched_files.size} files."
end
