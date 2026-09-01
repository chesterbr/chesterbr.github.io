---
name: archive-blog-link
description: Point every occurrence of a known-dead URL at its closest archive.org snapshot (the earliest one at or after each referencing post's own publish date), verifies the build, and commits to main locally (does not push - leaves that for the user to batch with other link fixes). No live-check of the old URL - use this when the user already knows a link is dead (found it by hand, or a check already failed) and just wants it archived, not re-verified.
user-invocable: true
allowed-tools:
  - Read
  - Edit
  - Grep
  - Glob
  - Bash
---

# /archive-blog-link — point a dead link at its archive.org snapshot

Arguments passed: `$ARGUMENTS`

This is chesterbr.github.io, a Jekyll blog. It has an established
convention for dead links (`class="dead-link"` styling - see below) and
a companion skill, `update-blog-link`, for swapping in a live
replacement. This skill is for the case where there's no live
replacement to swap in - the user wants the dead URL pointed at the
closest archive.org snapshot instead, and has already decided it's dead
(don't re-verify that part, just find it and archive it).

The one thing that makes this different from a plain URL swap: posts
referencing the same dead URL were often written years apart. "The
closest archive.org snapshot" means closest *to when that specific post
was written*, not one snapshot reused everywhere - so each occurrence
may end up pointing at a different timestamp.

## 1. Get the URL

Parse `$ARGUMENTS` as a single URL. If empty or not URL-shaped, ask the
user for it. Unlike `update-blog-link`, there's no second (replacement)
URL to gather - that's the whole point of this skill.

## 2. Find every occurrence

First, exact-string match, not a domain-wide search (that's deliberate
- see below):

```
grep -rl --fixed-strings "THE_EXACT_URL" _posts/
```

If that finds nothing, the URL might already be sitting inside an
*earlier* archive.org snapshot instead of appearing plainly - e.g. a
prior run of this skill pointed it at
`http://web.archive.org/web/OLD_TIMESTAMP/THE_EXACT_URL`, and that
snapshot has since turned out to be bad, so the user is re-running this
to get a better one. archive.org embeds the original URL inside its
own, so search again for just the URL's *core* (strip the
`http://`/`https://` scheme and any trailing slash) as a substring:

```
grep -rl --fixed-strings "URL_CORE" _posts/
```
When a match comes from this fallback, the occurrence to replace is
whatever href is actually there (the earlier, now-bad, archive.org
URL) - treat it the same as the "already marked dead" case in step 4
below (replace the whole href with the freshly-looked-up snapshot),
even if it isn't wrapped in `dead-link` styling.

If nothing turns up in `_posts/` either way, also check root-level
content pages the same way `update-blog-link` does (`--include=*.md
--include=*.html .`, excluding `_site/`, `vendor/`, `.git/`). If
genuinely nothing matches, say so and stop - don't guess at a near-miss
URL or broaden to the bare domain. (This skill intentionally doesn't do
`update-blog-link`'s domain-wide fallback search: that exists there
because a *replacement* URL often lives at a different path than the
original post's link, post-migration. Here the URL isn't changing
shape, so exact/core match is the safer default.)

This includes occurrences already wrapped in dead-link markup (a link
marked dead earlier, for which a snapshot has now turned up) as well as
plain Markdown/HTML/reference-style links.

## 3. Look up the closest snapshot, per post date

For each occurrence, find that *post's* publish date first: check its
own front matter `date:`, else parse the `YYYY-MM-DD` prefix off the
filename. Format as `YYYYMMDD`.

Only do one lookup per distinct post date involved - if the same post
has two occurrences of the URL, or two posts happen to share a
publish date, they share a lookup.

```bash
python3 - "$URL" "$POST_DATE_YYYYMMDD" <<'PYEOF'
import sys, json, urllib.parse, urllib.request

url, post_date = sys.argv[1], sys.argv[2]
encoded = urllib.parse.quote(url, safe="")

def cdx(extra):
    api = f"http://web.archive.org/cdx/search/cdx?url={encoded}&output=json&limit=5{extra}"
    with urllib.request.urlopen(api, timeout=15) as r:
        return json.load(r)

rows = cdx(f"&from={post_date}")
if len(rows) > 1:
    ts, orig = rows[1][1], rows[1][2]        # earliest snapshot at/after the post date
else:
    rows = cdx(f"&to={post_date}")
    if len(rows) > 1:
        ts, orig = rows[-1][1], rows[-1][2]  # closest snapshot before it, as fallback
    else:
        print("NO_SNAPSHOT")
        sys.exit(0)

print(f"http://web.archive.org/web/{ts}/{orig}")
PYEOF
```

If this prints `NO_SNAPSHOT`, that post's occurrence has no usable
archive - tell the user and suggest `mark-blog-link-dead` for it
instead of guessing. Other occurrences (with different post dates that
do have a snapshot) can still proceed.

## 4. Replace, per occurrence

Same shapes `update-blog-link` handles, landing on the snapshot URL
found for that occurrence's post date instead of a user-supplied
replacement:

**Plain/reference-style** - swap the URL:
```
[text](URL)          -> [text](SNAPSHOT_URL)
<a href="URL">        -> <a href="SNAPSHOT_URL">
[ref]: URL            -> [ref]: SNAPSHOT_URL
```

**Already marked dead** - replace the whole thing with a plain link,
dropping `class`, `title`, and the trailing `†` marker:
```html
<a class="dead-link" title="TITLE" href="URL">text</a><span class="dead-link-mark">†</span>
```
becomes
```html
<a href="SNAPSHOT_URL">text</a>
```

Use Edit, not sed - surrounding text/attributes vary per occurrence.

## 5. Verify

```
bundle exec jekyll build
```
Must succeed. Grep the built `_site` output for the affected post(s),
confirming each snapshot URL landed and the original dead URL is gone
(unless intentionally still mentioned in prose). Skip the full
`html-proofer` suite - large pre-existing unrelated failure count, just
noise here.

Clean up: `rm -rf _site .jekyll-cache .jekyll-metadata`.

## 6. Show the diff, then commit (don't push)

```
git diff -- _posts/
```
Show it. If `git status` shows *other* unrelated uncommitted changes
before you start, stop and ask rather than sweeping them into this
commit. Otherwise:

```
git add -A
git commit -m "archive dead link: URL"
```

Commit straight to `main` locally - no branch/PR, same rationale as
`update-blog-link`: branch protection isn't enabled, and this is as
low-risk as changes get. But **don't run `git push`** unless the user
explicitly asks for it in this invocation: they often queue up several
link fixes in a row (this skill and its siblings `update-blog-link`,
`mark-blog-link-dead`, `mark-blog-link-live`) and want one push - and
one deploy - covering all of them, not one deploy per link.

If different occurrences landed on different snapshot timestamps
(different post dates), say so in the commit body - list each affected
post and the exact snapshot URL it got, so it's clear at a glance this
wasn't one uniform swap:

```
archive dead link: URL

- _posts/2012-11-25-some-post.md -> http://web.archive.org/web/TS1/URL
- _posts/2018-03-02-another-post.md -> http://web.archive.org/web/TS2/URL
```
