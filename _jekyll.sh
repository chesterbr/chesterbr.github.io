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
  POST_COUNT=$(find _posts -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')
  PAGEFIND_LOG=$(mktemp)
  npx -y pagefind@1.5.2 --site _site --force-language pt > "$PAGEFIND_LOG" 2>&1 || true
  # Legacy posts keep a redirect stub at their old literal ".html" permalink
  # (see the permalink-migration commit); Pagefind's crawler mistakes that
  # directory for a file and logs this once per stub. Harmless - filtered here
  # so it doesn't bury a real problem. The indexed-count check below is what
  # actually guards against posts silently going missing from search again.
  grep -v "Is a directory (os error 21)" "$PAGEFIND_LOG" || true
  INDEXED=$(grep -oE "Indexed [0-9]+ pages" "$PAGEFIND_LOG" | tail -1 | grep -oE "[0-9]+" || true)
  if [ -z "$INDEXED" ] || [ "$INDEXED" -lt "$POST_COUNT" ]; then
    echo "WARNING: Pagefind indexed only ${INDEXED:-0} pages, expected at least $POST_COUNT - some posts may be missing from search!"
  fi
  rm -f "$PAGEFIND_LOG"
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
