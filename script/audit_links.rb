#!/usr/bin/env ruby
# frozen_string_literal: true

# Runs HTMLProofer against the built post pages (_site/archives) to find
# broken internal links/images and dead external links. Writes structured
# findings to tmp/link_audit.csv for human review; does not fix anything.
#
# Usage: bundle exec jekyll build && bundle exec ruby script/audit_links.rb

require "csv"
require "html-proofer"
require "fileutils"

SITE_DIR = File.expand_path("../_site", __dir__)
ARCHIVES_DIR = File.join(SITE_DIR, "archives")
OUT_CSV = File.expand_path("../tmp/link_audit.csv", __dir__)

unless Dir.exist?(ARCHIVES_DIR)
  abort "#{ARCHIVES_DIR} not found — run `bundle exec jekyll build` first."
end

options = {
  root_dir: SITE_DIR, # so absolute internal paths (e.g. /apple-icon-57x57.png) resolve against the whole site, not just archives/
  enforce_https: false, # not auditing protocol, just reachability
  ignore_missing_alt: true, # accessibility pass is a separate future concern, not this audit
  check_external_hash: false, # avoid noise/flakiness from anchor-perfect checks on external pages
  ignore_status_codes: [999], # LinkedIn and some sites always return 999 to bots; not a real signal
  ignore_urls: [%r{i\.creativecommons\.org}, %r{fonts\.googleapis\.com}], # protocol-relative by design in the old theme, not a defect worth 662 rows
  disable_external: ENV["INTERNAL_ONLY"] == "1", # fast dry run: ruby script/audit_links.rb (with INTERNAL_ONLY=1)
  typhoeus: { connecttimeout: 10, timeout: 20 },
  hydra: { max_concurrency: 20 },
  log_level: :warn,
}

runner = HTMLProofer.check_directory(ARCHIVES_DIR, options)

begin
  runner.run
rescue SystemExit
  # html-proofer exits(1) when it finds failures; we still want the structured list below
end

failures = runner.failed_checks

# The same broken resource (a shared template asset, a repeated footer badge,
# a link that appears both on a post's own page and in the /archives listing)
# shows up once per rendered page with an identical description. Group by the
# description text so systemic issues collapse into one row with a count,
# instead of flooding the report with 661 near-identical lines.
groups = failures.group_by { |f| [f.check_name, f.status, f.description] }

FileUtils.mkdir_p(File.dirname(OUT_CSV))

CSV.open(OUT_CSV, "w") do |csv|
  csv << %w[check_name status occurrences example_file all_files detail]
  groups.each_value do |group|
    rel_paths = group.map { |f| f.path.to_s.sub("#{ARCHIVES_DIR}/", "") }.uniq
    f = group.first
    shown = rel_paths.first(5).join(" | ")
    shown += " | +#{rel_paths.size - 5} more" if rel_paths.size > 5
    csv << [f.check_name, f.status, group.size, rel_paths.first, shown, f.description]
  end
end

puts "Wrote #{groups.size} unique findings (#{failures.size} raw occurrences) to #{OUT_CSV}"
counts = failures.group_by(&:check_name).transform_values(&:size)
counts.each { |k, v| puts "  #{k}: #{v} raw occurrences" }
