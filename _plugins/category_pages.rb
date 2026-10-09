# Generates one listing page per entry in _data/categories.yml, at the entry's
# `url`, rendered with _layouts/category.html.
module Jekyll
  class CategoryPageGenerator < Generator
    safe true
    # Must run before jekyll-redirect-from so it sees `redirect_from` on these pages.
    priority :high

    def generate(site)
      site.data["categories"].each do |cat|
        page = PageWithoutAFile.new(site, site.source, cat["url"], "index.html")
        page.data.merge!(
          "layout"       => "category",
          "robots"       => "noindex, follow",
          "sitemap"      => false,
          "title"        => cat["label"]["en"],
          "description"  => cat["description"],
          "hide_heading" => true,
          "category"     => cat["slug"],
          "redirect_from" => cat["redirect_from"]
        ).compact!
        site.pages << page
      end
    end
  end
end
