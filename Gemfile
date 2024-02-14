source "https://rubygems.org"

gem "bundler"

# Ruby 3.3 compatible Jekyll
gem "jekyll", "~> 3.9.4"

# This gem is required for GitHub Pages
gem "kramdown-parser-gfm"

# This is the default theme for new Jekyll sites. You may change this to anything you like.
gem "minima"

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-redirect-from"
  gem "jekyll-paginate"
  gem "jekyll-sitemap"
  # gem "jekyll-admin", github: "chesterbr/jekyll-admin" #, branch: "chesterbr/bump-sinatra-and-rake"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Ruby 3.0 does not include webrick anymore
gem 'webrick'

# This is used by the custom plugin sanitize_html, needed for the comment system
gem 'sanitize'

# Comply with these warnings until maintainers get their ducks aligned
# /Users/chesterbr/.rbenv/versions/3.3.0/lib/ruby/gems/3.3.0/gems/jekyll-3.9.4/lib/jekyll.rb:28: warning: csv was loaded from the standard library, but will no longer be part of the default gems since Ruby 3.4.0. Add csv to your Gemfile or gemspec. Also contact author of jekyll-3.9.4 to add csv into its gemspec.
# /Users/chesterbr/.rbenv/versions/3.3.0/lib/ruby/gems/3.3.0/gems/safe_yaml-1.0.5/lib/safe_yaml/transform.rb:1: warning: base64 was loaded from the standard library, but will no longer be part of the default gems since Ruby 3.4.0. Add base64 to your Gemfile or gemspec. Also contact author of safe_yaml-1.0.5 to add base64 into its gemspec.
# /Users/chesterbr/.rbenv/versions/3.3.0/lib/ruby/gems/3.3.0/gems/liquid-4.0.4/lib/liquid/standardfilters.rb:2: warning: bigdecimal was loaded from the standard library, but will no longer be part of the default gems since Ruby 3.4.0. Add bigdecimal to your Gemfile or gemspec. Also contact author of liquid-4.0.4 to add bigdecimal into its gemspec.
gem 'csv'
gem 'base64'
gem 'bigdecimal'
