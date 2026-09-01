---
name: mark-blog-link-live
description: Remove dead-link styling (strikethrough + dagger) from every occurrence of a URL that's actually back online, verifies the build, and pushes straight to main. No live-check - use this when the user has already confirmed by hand that a link previously marked dead is working again.
user-invocable: true
allowed-tools:
  - Read
  - Edit
  - Grep
  - Glob
  - Bash
---

# /mark-blog-link-live — un-mark a link that's back online

Arguments passed: `$ARGUMENTS`

This is chesterbr.github.io, a Jekyll blog, with an established
dead-link convention (`class="dead-link"` + a `†` marker - see below).
This skill is the exact inverse of `mark-blog-link-dead`: the user found
a link marked dead that's actually working again (site came back, or
whatever check originally marked it dead was wrong) and wants the
styling removed. No live-check here either - if they're invoking this,
they've already confirmed it by hand.

## 1. Get the URL

Parse `$ARGUMENTS` as a single URL. If empty or not URL-shaped, ask the
user for it.

## 2. Find every dead-marked occurrence

Search specifically for this URL *in dead-link form* - not just any
mention of it:

```
grep -rl --fixed-strings "THE_EXACT_URL" _posts/
```
then, among those matches, confirm each one actually has the
`class="dead-link"` wrapper around this URL (not just a plain mention of
it elsewhere in the same post).

If nothing turns up in `_posts/`, also check root-level content pages
(`--include=*.md --include=*.html .`, excluding `_site/`, `vendor/`,
`.git/`). If the URL isn't found in dead-link form anywhere, say so and
stop - don't guess. (Maybe it was never marked dead, maybe it's already
been revived.)

## 3. Revive each occurrence

Convert:
```html
<a class="dead-link" title="TITLE" href="URL">text</a><span class="dead-link-mark">†</span>
```
to a plain link, dropping `class`, `title`, and the trailing `†` marker
entirely:
```html
<a href="URL">text</a>
```

Use Edit, not sed - surrounding text varies per occurrence.

## 4. Verify

```
bundle exec jekyll build
```
Must succeed. Grep the built `_site` output for the affected post(s),
confirming the `dead-link` class/marker are gone and a plain link to
`URL` remains. Skip the full `html-proofer` suite - large pre-existing
unrelated failure count, just noise here.

Clean up: `rm -rf _site .jekyll-cache .jekyll-metadata`.

## 5. Show the diff, then commit and push to main

```
git diff -- _posts/
```
Show it. If `git status` shows *other* unrelated uncommitted changes
before you start, stop and ask rather than sweeping them into this
commit. Otherwise:

```
git add -A
git commit -m "mark link live again: URL"
git push
```

Straight to `main`, no branch/PR - same rationale as `update-blog-link`:
no branch protection, the deploy workflow only triggers on push to
`main` either way, and this is as low-risk as changes get. If multiple
posts had the same URL marked dead, one commit covering all of them is
fine.
