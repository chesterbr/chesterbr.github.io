source "https://rubygems.org"

gem "bundler"

gem "jekyll", "~> 3.10.0"
gem "kramdown-parser-gfm", "~> 1.1"
gem "minima", "~> 2.5"
gem "sanitize", "~> 7.0"
gem "jekyll-sass-converter", "~> 1.5.2"

group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.17"
  gem "jekyll-redirect-from", "~> 0.16"
  gem "jekyll-paginate-v2", "~> 3.0"
  gem "jekyll-sitemap", "~> 1.4"
  gem "jekyll-gist", "~> 1.5"
  gem "jekyll-optional-front-matter", "~> 0.3"
  gem "jekyll-default-layout", "~> 0.1.5"
  gem "jekyll-titles-from-headings", "~> 0.5.3"
end

group :development do
  gem 'html-proofer'
  # Ruby 3.0 does not include webrick anymore; only `jekyll serve` (local
  # dev) needs it, not `jekyll build` (what CI runs).
  gem 'webrick'
end
