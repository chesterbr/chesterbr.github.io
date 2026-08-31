#!/usr/bin/env ruby
# frozen_string_literal: true

# Heuristic scan of raw post source for markdown/HTML defects left over from
# past platform migrations (MovableType -> WordPress -> Octopress -> Jekyll).
# This does not touch rendered output (see audit_links.rb for that); it flags
# likely issues for human review, it does not auto-fix anything.

require "csv"
require "fileutils"

POSTS_DIR = File.expand_path("../_posts", __dir__)
OUT_CSV = File.expand_path("../tmp/content_audit.csv", __dir__)

BALANCED_TAGS = %w[span b strong i em div].freeze
# standalone WP/MT shortcode, e.g. [gallery ids="1,2,3"] or [/caption] -- NOT a markdown
# link whose text happens to start with one of these words, e.g. [video "title"][1]
SHORTCODE_RE = /\[(gallery|caption|embed|audio|video|\/caption)\b[^\]]*\](?!\[|\()/.freeze
DOUBLE_ENCODED_ENTITY_RE = /&amp;#x?[0-9a-fA-F]+;/.freeze
MT_ENCLOSURE_RE = /mt-enclosure/.freeze
MD_REF_LINK_USE_RE = /\[([^\]]+)\]\[([^\]]*)\]/.freeze
MD_REF_LINK_DEF_RE = /^\s*\[([^\]]+)\]:\s*\S+/.freeze
FLICKR_RE = /flickr\.com|staticflickr\.com/i.freeze
IMG_TAG_RE = /<img\b[^>]*>/.freeze

def parse_frontmatter(text)
  return [{}, text] unless text.start_with?("---\n")

  fm_end = text.index("\n---", 4)
  return [{}, text] unless fm_end

  fm_text = text[4...fm_end]
  body = text[(fm_end + 4)..] || ""
  [fm_text, body]
end

rows = []

Dir.glob(File.join(POSTS_DIR, "*.{md,markdown}")).sort.each do |path|
  fname = File.basename(path)
  text = File.read(path, encoding: "utf-8")
  _fm, body = parse_frontmatter(text)

  # tags mentioned in prose (fenced code blocks, inline `code`) aren't real markup;
  # strip them before counting so e.g. a post that *talks about* `<div>` doesn't
  # get flagged as unbalanced
  tag_check_body = body.gsub(/```.*?```/m, " ").gsub(/`[^`]*`/, " ")

  # 1. Unbalanced common inline/block tags (heuristic: raw open/close count, not a real parser)
  BALANCED_TAGS.each do |tag|
    opens = tag_check_body.scan(/<#{tag}(?:\s[^>]*)?>/i).size
    closes = tag_check_body.scan(%r{</#{tag}>}i).size
    next if opens == closes

    rows << { file: fname, category: "unbalanced-tag", detail: "<#{tag}>: #{opens} open vs #{closes} close", url_or_snippet: "", http_status: "", note: "" }
  end

  # 2. WordPress/MovableType shortcode remnants
  body.scan(SHORTCODE_RE).each do |m|
    rows << { file: fname, category: "shortcode-remnant", detail: "[#{m[0]}...]", url_or_snippet: "", http_status: "", note: "likely unrendered WP/MT shortcode" }
  end

  # 3. Double-encoded HTML entities
  body.scan(DOUBLE_ENCODED_ENTITY_RE).uniq.each do |m|
    rows << { file: fname, category: "double-encoded-entity", detail: m, url_or_snippet: "", http_status: "", note: "" }
  end

  # 4. MovableType mt-enclosure wrapper spans
  if body.match?(MT_ENCLOSURE_RE)
    count = body.scan(MT_ENCLOSURE_RE).size
    rows << { file: fname, category: "mt-enclosure-leftover", detail: "#{count} occurrence(s)", url_or_snippet: "", http_status: "", note: "MovableType image-wrapper markup, may be redundant with plain <img>/markdown image" }
  end

  # 5. Dangling markdown reference-style links (used but not defined)
  defined_refs = body.scan(MD_REF_LINK_DEF_RE).flatten.map(&:downcase)
  body.scan(MD_REF_LINK_USE_RE).each do |(_text, ref)|
    ref_key = (ref.empty? ? _text : ref).downcase
    next if defined_refs.include?(ref_key)

    rows << { file: fname, category: "dangling-ref-link", detail: "[#{_text}][#{ref}]", url_or_snippet: "", http_status: "", note: "no matching [#{ref.empty? ? _text : ref}]: url definition found" }
  end

  # 6. Flickr references (separate pass, every one listed for manual eyeballing)
  body.scan(/https?:\/\/[^\s")>\]]*(?:flickr\.com|staticflickr\.com)[^\s")>\]]*/i).uniq.each do |url|
    is_img = body.scan(IMG_TAG_RE).any? { |tag| tag.include?(url) }
    rows << { file: fname, category: "flickr-reference", detail: is_img ? "img-embed" : "link", url_or_snippet: url, http_status: "", note: "" }
  end
end

FileUtils.mkdir_p(File.dirname(OUT_CSV))

CSV.open(OUT_CSV, "w") do |csv|
  csv << %w[file category detail url_or_snippet http_status note]
  rows.each do |r|
    csv << [r[:file], r[:category], r[:detail], r[:url_or_snippet], r[:http_status], r[:note]]
  end
end

puts "Wrote #{rows.size} findings to #{OUT_CSV}"
counts = rows.group_by { |r| r[:category] }.transform_values(&:size)
counts.each { |k, v| puts "  #{k}: #{v}" }
