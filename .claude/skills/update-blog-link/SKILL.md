---
name: update-blog-link
description: Replace a dead or outdated URL in blog posts with a working replacement - finds every post linking to the old URL, swaps it in, removes dead-link styling if present, verifies the build, and pushes straight to main. Use when the user found a broken/outdated link on the blog (marked dead-link or not) and has, or wants help finding, a live replacement.
user-invocable: true
allowed-tools:
  - Read
  - Edit
  - Grep
  - Glob
  - Bash
  - WebSearch
  - WebFetch
---

# /update-blog-link — swap a dead link for a live replacement

Arguments passed: `$ARGUMENTS`

This is chesterbr.github.io, a Jekyll blog. It went through a big dead-link
audit earlier (posts in `_posts/*.md`, `class="dead-link"` styling — see
below), but that sweep was automated and imperfect: the user finds
unmarked dead links by hand while reading, occasionally with a working
replacement already in mind. This skill exists to make fixing one of those
a single quick round-trip, not a whole editing session.

## 1. Get the two URLs

Parse `$ARGUMENTS`. If it contains exactly two whitespace-separated
tokens that look like URLs, treat the first as `OLD_URL` and the second as
`NEW_URL`. Otherwise (empty args, one URL, or free text describing the
situation), ask the user for whichever of the two you're missing. If the
user only has the old (dead) URL and no replacement, ask whether they
want you to search for one (e.g. check archive.org via the pattern in
"No replacement found" below) or just mark it dead instead — don't
silently pick one path.

## 2. Sanity-check the new URL

`curl -sI -L --max-time 10 -o /dev/null -w "%{http_code}" "NEW_URL"` (the
`-L` follows redirects, matching how a browser would resolve it). A
2xx/3xx status is fine. If it's not, tell the user before doing anything
else — don't replace one dead link with another. Some sites 403 curl's
default UA; if you get a 403, retry once with
`-A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"`
before concluding it's actually broken (this matched a real false-positive
pattern from the original audit).

## 3. Find every occurrence

Search on the bare domain, not just the exact `OLD_URL` string - posts
often link to different paths on the same dead domain, not always the
literal URL the user gave you:

```
grep -rln --fixed-strings "the-domain.tld" _posts/
```

Also check root-level content pages if nothing turns up in `_posts/`
(`grep -rln --fixed-strings "the-domain.tld" --include=*.md --include=*.html .`
excluding `_site/`, `vendor/`, `.git/`). If genuinely nothing matches,
say so and stop rather than guessing at a near-miss URL.

**For each match, check whether its path matches `OLD_URL` exactly.** If
`OLD_URL` was given as a bare domain (or the match's path differs from
it), don't assume swapping just the domain onto that match's path
produces a live page - sanity-check that *specific* resulting URL the
same way you checked `NEW_URL` in step 2 (curl -sI -L). A domain
migration doesn't always preserve URL structure or even keep the same
content (a book's publisher can change, e.g.). If a per-post swap 404s,
don't guess a fix - tell the user what you found (the dead deep link,
that the domain-only swap doesn't cover it) and ask how to proceed:
search for a real replacement (WebSearch/WebFetch, or that post's
publisher/site directly), fall back to an archive.org snapshot of the
old URL, or mark it dead-link instead. Only apply the given `OLD_URL`
-> `NEW_URL` swap directly to matches whose path actually corresponds.

## 4. Replace it, per occurrence

Two shapes to handle:

**Plain link** (most common) - just swap the URL:
```
[text](OLD_URL)          -> [text](NEW_URL)
<a href="OLD_URL">        -> <a href="NEW_URL">
[ref]: OLD_URL             -> [ref]: NEW_URL
```

**Marked dead** - this URL already got the dead-link treatment from the
original audit:
```html
<a class="dead-link" title="TITLE" href="OLD_URL">text</a><span class="dead-link-mark">†</span>
```
Replace the *whole thing* with a plain link, dropping the class, title,
and the trailing `†` marker entirely:
```html
<a href="NEW_URL">text</a>
```
(`TITLE` is `"this link died"` for `lang: en` posts or `"este link
morreu"` for `lang: pt-BR` posts, per the post's own front matter - not
relevant to the replacement, just how to recognize the pattern.)

Use Edit, not sed - the surrounding text/attributes vary per occurrence
and you want to see the diff.

## 5. Verify

```
bundle exec jekyll build
```
Must succeed. Then confirm the specific change landed - grep the built
`_site` output for the affected post(s) for `NEW_URL` (present) and
`OLD_URL` (absent, unless it's intentionally still mentioned in prose).
Don't run the full `html-proofer` suite here - it has a large pre-existing
failure count from unrelated known issues and would just add noise for a
single-link change.

Clean up: `rm -rf _site .jekyll-cache .jekyll-metadata`.

## 6. Show the diff, then commit and push to main

```
git diff -- _posts/
```
Show it. Then, assuming it's just the intended URL swap(s):

```
git add -A
git commit -m "fix dead link: OLD_URL -> NEW_URL"
git push
```

Straight to `main`, no branch/PR - confirmed with the user that a PR
buys nothing here (the deploy workflow only triggers on push to `main`
either way, and branch protection isn't enabled), and a single-URL swap
is about as low-risk as a change gets. If `git status` shows *other*
unrelated uncommitted changes before you start, stop and ask rather than
sweeping them into this commit.

If multiple posts needed the same swap, one commit covering all of them
is fine - no need to split them up.

## No replacement found

If the user wants you to search rather than supply a URL yourself: try
`https://web.archive.org/web/2/OLD_URL` (redirects to the most recent
snapshot) as a first, zero-effort option, matching the archive.org
fallback pattern from the original dead-link audit. If that doesn't pan
out, say so - don't guess at an unrelated URL.
