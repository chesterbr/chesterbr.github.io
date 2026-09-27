#!/bin/bash
# Local dev server for the blog.
#
# Beyond a plain `jekyll serve`, this also builds the Pagefind search index
# (the same step CI runs in pages.yml) so search works locally. Order matters:
# Jekyll builds _site, then Pagefind indexes that HTML, then we serve without
# rebuilding. keep_files: ["pagefind"] in _config.yml stops the watch server's
# rebuilds from deleting the index while you edit.
#
# The index is a snapshot from startup - edits to posts won't show up in search
# until you re-run this script. (Re-indexing on every save would mean a ~40s
# Pagefind run per keystroke, so it's deliberately a startup-only step.)
set -e

# Uncomment if needed (codespaces should supply a Ruby)
# rbenv install --skip-existing
bundle

# Build the site, then index it. Pagefind version + flags match pages.yml so
# local search behaves like production (one cross-language index).
bundle exec jekyll build
if command -v npx >/dev/null 2>&1; then
  npx -y pagefind@1.5.2 --site _site --force-language pt \
    || echo "WARNING: Pagefind index build failed - local search will be empty."
else
  echo "WARNING: npx/Node not found - skipping Pagefind index; local search will be empty."
fi

echo "=============================================="
echo " Serving on http://localhost:4000  (admin at /admin)"
echo " Search is a startup snapshot - re-run this script to refresh it after editing posts."
echo "=============================================="

# --skip-initial-build: keep the _site we just built + indexed instead of
# cleaning it. --incremental: fast rebuilds on edits (index is preserved by
# keep_files above).
bundle exec jekyll serve --incremental --skip-initial-build
