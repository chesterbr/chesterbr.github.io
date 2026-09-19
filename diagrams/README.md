# diagrams/

Source files and notes for the diagrams used in blog posts.

This folder is **not published**: it is listed in `exclude:` in `_config.yml`, so
Jekyll never copies it into `_site`. Keep the editable diagram sources here; the
rendered images that posts actually reference live under `img/`.

## Current approach (as of 2026-09)

Diagrams are **authored in [Mermaid](https://mermaid.js.org/)** (text, versionable,
easy to tweak) but **shipped as static SVG** committed to `img/`. Posts embed the
SVG like any other image, so the reader downloads a few KB and **zero JavaScript**.

Why not client-side Mermaid (the usual `jekyll-mermaid` / Mermaid-in-a-`<script>`
route): it ships ~1-2 MB of `mermaid.js` to the browser on every page with a
diagram. That fights this blog's whole point (fast, minimal, no runtime deps on
third parties), so we render ahead of time instead.

Convention: keep the source as `diagrams/<name>.mmd`, render to `img/<name>.svg`,
reference `/img/<name>.svg` from the post.

## Rendering a diagram by hand

Uses [mermaid-cli](https://github.com/mermaid-js/mermaid-cli) (`mmdc`), which pulls
Node + a headless Chromium (puppeteer):

```sh
npm install -g @mermaid-js/mermaid-cli        # one-time
mmdc -i diagrams/comment-pipeline.mmd -o img/comment-pipeline.svg
```

Then commit both the `.mmd` and the `.svg`.

## If diagrams become frequent: build-time auto-render (a.k.a. "option 1")

Instead of rendering by hand, let the build turn ```` ```mermaid ```` fenced blocks
into inline SVG automatically. This site is built by a GitHub Actions workflow
(`.github/workflows/pages.yml` runs `bundle exec jekyll build`), so custom gems and
build steps are allowed (unlike GitHub Pages' restricted native build).

Setup (do this once, only when it's worth it):

1. Add a gem, e.g. [`jekyll-mermaid-prebuild`](https://rubygems.org/gems/jekyll-mermaid-prebuild)
   (mermaid-only, caches SVGs) or [`jekyll-diagrams`](https://www.rubydoc.info/gems/jekyll-diagrams)
   (multi-tool: Mermaid, PlantUML, GraphViz, ...) to the `:jekyll_plugins` group in
   the `Gemfile` and to `plugins:` in `_config.yml`.
2. Make `mmdc` available in the build: add `actions/setup-node` + a
   `npm install -g @mermaid-js/mermaid-cli` step to `pages.yml` before the Jekyll
   build. This downloads Chromium, so CI gets a bit heavier/slower.
3. Write ```` ```mermaid ```` blocks directly in posts; the plugin renders static
   SVG at build time. Locally, install mermaid-cli so `jekyll serve` previews work.

The trade-off is the Chromium/puppeteer dependency in CI (and locally). If that's
unwanted, [`jekyll-kroki`](https://github.com/felixvanoost/jekyll-kroki) swaps the
local renderer for a build-time call to a [Kroki](https://kroki.io/) server (public
or self-hosted): output stays static SVG, no local Chromium, but the build depends
on that server.

## References

- [jekyll-mermaid-prebuild](https://rubygems.org/gems/jekyll-mermaid-prebuild)
- [jekyll-diagrams](https://www.rubydoc.info/gems/jekyll-diagrams)
- [jekyll-kroki](https://github.com/felixvanoost/jekyll-kroki)
- [Mermaid Diagramming in Jekyll in 2025](https://stuff-things.net/2025/01/19/mermaid-diagramming-in-jekyll-in-2025/)
