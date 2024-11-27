source "https://rubygems.org"

gem "github-pages", group: :jekyll_plugins

# If you have any plugins, put them here!
# group :jekyll_plugins do
#   # gem "jekyll-admin", github: "chesterbr/jekyll-admin" #, branch: "chesterbr/bump-sinatra-and-rake"
# end

# Ruby 3.0 does not include webrick anymore, but if we do, Actions issues a warning
# See https://github.com/github/pages-gem/issues/887
install_if -> { ENV["GITHUB_ACTIONS"] != "true" } do
    puts "Is GitHub action: #{ENV["GITHUB_ACTIONS"] == "true"}"
    gem "webrick"
end
