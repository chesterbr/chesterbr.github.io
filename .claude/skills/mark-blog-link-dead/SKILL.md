---
name: mark-blog-link-dead
description: Mark every occurrence of a URL as dead (strikethrough + dagger, the site's established dead-link convention), verifies the build, and commits to main locally (does not push - leaves that for the user to batch with other link fixes). No live-check - use this when the user already knows a link is dead (found it by hand, or an automated check already failed) and just wants it marked, not re-verified.
user-invocable: true
allowed-tools:
  - Read
  - Edit
  - Grep
  - Glob
  - Bash
---

# /mark-blog-link-dead — mark a link dead without checking it

Arguments passed: `$ARGUMENTS`

This is chesterbr.github.io, a Jekyll blog, with an established
dead-link convention (`class="dead-link"` + a `†` marker - see below)
from an earlier site-wide audit. That audit's tooling (and the sibling
skills `update-blog-link` / `archive-blog-link`) live-check a link
before touching it. This skill deliberately skips that: if the user is
invoking it, it's because they've already confirmed by hand (or an
automated check already told them) that the link is dead. Don't
re-verify - just find every occurrence and mark it.

## 1. Get the URL

Parse `$ARGUMENTS` as a single URL. If empty or not URL-shaped, ask the
user for it.

## 2. Find every occurrence

First, exact-string match:

```
grep -rl --fixed-strings "THE_EXACT_URL" _posts/
```

If that finds nothing, the URL might currently be sitting inside an
archive.org snapshot wrapper instead of appearing plainly - e.g. a
prior `/archive-blog-link` run pointed it at
`http://web.archive.org/web/TIMESTAMP/THE_EXACT_URL`, and now *that*
snapshot has turned out to be bad and needs marking dead too.
archive.org embeds the original URL inside its own, so search again for
just the URL's *core* (strip the `http://`/`https://` scheme and any
trailing slash) as a substring:

```
grep -rl --fixed-strings "URL_CORE" _posts/
```

This also catches trivial formatting differences (http vs https,
trailing slash) in a plain link. Whatever match this turns up, look at
the actual href in context before touching it - don't assume it's
textually identical to the URL you were given; it might be a plain link
with slightly different formatting, or an archive.org-wrapped one.
Either way, mark *that* href dead as found - don't rewrite it to
something else first.

If nothing turns up in `_posts/` either way, also check root-level
content pages (`--include=*.md --include=*.html .`, excluding `_site/`,
`vendor/`, `.git/`). If genuinely nothing matches, say so and stop -
don't guess at a near-miss URL.

## 3. Mark each occurrence

For each match, first check whether it's *already* in dead-link form
(see the pattern below) - if so, leave it alone and note it's already
marked.

For every other occurrence - plain Markdown `[text](URL)`, raw HTML
`<a href="URL">text</a>` (`URL` here being whatever the actual href is -
a plain link or an archive.org-wrapped one, per step 2), or
reference-style (`[text][ref]` used with a `[ref]: URL` definition at
the bottom of the file) - convert it to the site's dead-link markup,
keeping that same href value unchanged:

```html
<a class="dead-link" title="TITLE" href="URL">text</a><span class="dead-link-mark">†</span>
```

- Attribute order is always `class`, `title`, `href`.
- `<span class="dead-link-mark">†</span>` immediately abuts `</a>`, no
  space.
- `TITLE` is `"this link died"` for `lang: en` posts, `"este link
  morreu"` for `lang: pt-BR` posts - read the post's own front matter
  (`lang`/`locale`) to pick the right one per post.
- Always end up as raw HTML, even when the original was Markdown or
  reference-style - markdown link syntax can't carry a `class`/`title`.
  For a reference-style link, replace the `[text][ref]` usage with the
  raw HTML pattern above, and remove the `[ref]: URL` definition line
  too, but only if nothing else in the post still uses that reference.

Use Edit, not sed - surrounding text/attributes vary per occurrence.

If literally every occurrence found is already dead-marked, say so and
stop - there's nothing to do.

## 4. Verify

```
bundle exec jekyll build
```
Must succeed. Grep the built `_site` output for the affected post(s),
confirming the `dead-link` class and marker landed. Skip the full
`html-proofer` suite - large pre-existing unrelated failure count, just
noise here.

Clean up: `rm -rf _site .jekyll-cache .jekyll-metadata`.

## 5. Show the diff, then commit (don't push)

```
git diff -- _posts/
```
Show it. If `git status` shows *other* unrelated uncommitted changes
before you start, stop and ask rather than sweeping them into this
commit. Otherwise:

```
git add -A
git commit -m "mark dead link: URL"
```

Commit straight to `main` locally - no branch/PR, same rationale as
`update-blog-link`: branch protection isn't enabled, and this is as
low-risk as changes get. But **don't run `git push`** unless the user
explicitly asks for it in this invocation: they often queue up several
link fixes in a row (this skill and its siblings `update-blog-link`,
`archive-blog-link`, `mark-blog-link-live`) and want one push - and one
deploy - covering all of them, not one deploy per link. If multiple
posts had the same URL, one commit covering all of them is fine.
