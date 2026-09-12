# chester's blog - comments intake Worker

Cloudflare Worker that replaces the old self-hosted Staticman. It receives the
comment form POST, filters spam, and writes the comment into this repo in the
same `_data/comments/{slug}/entry{ts}.yml` format Staticman used, so every
existing Jekyll include keeps rendering unchanged.

## Pipeline

| Stage | What happens |
|---|---|
| Door | honeypot + minimum fill time + Cloudflare Turnstile. Fails here are silently dropped (or a `captcha` error). No commit, no PR. |
| Akismet | classic spam check, called directly (no Staticman middleman). |
| Claude | second opinion via Haiku. Runs only when Akismet flags spam (`CLAUDE_ON=flagged_only`), or on every comment (`CLAUDE_ON=always`). |

Outcome:

| Akismet | Claude | Result |
|---|---|---|
| clean | (not run) | **auto-publish** (commit to `main`) |
| clean | spam (only if `always`) | **PR** (catches Akismet false-negative) |
| spam | legitimate | **PR** (filters disagree, human decides) |
| spam | unsure | **PR** |
| spam | spam | **reject** -> logged in `comments-rejected/{slug}/` |

`comments-rejected/` is excluded from the Jekyll build, so it never appears on
the site. Review it occasionally on GitHub to catch false positives; to rescue
one, move the file into `_data/comments/{slug}/`.

## Policy knobs (no code change)

Edit `vars` in `wrangler.jsonc`, then `npm run deploy`:

- `MODERATION_MODE`: `auto` (auto-publish clean) | `pr_all` (everything -> PR).
- `CLAUDE_ON`: `flagged_only` | `always`.
- `MIN_SECONDS`, `CLAUDE_MODEL`, repo/site vars.

## Setup

```bash
npm install
# one-time login (opens a browser):
npx wrangler login
```

Set the four secrets (values live only in Cloudflare + your password manager,
never in git):

```bash
npx wrangler secret put GITHUB_TOKEN      # fine-grained PAT: Contents + Pull requests (RW), this repo only
npx wrangler secret put TURNSTILE_SECRET  # Cloudflare Turnstile widget secret key
npx wrangler secret put AKISMET_KEY       # akismet.com API key
npx wrangler secret put ANTHROPIC_API_KEY # Anthropic API key (set a low spend cap)
```

Deploy:

```bash
npm run deploy      # prints the workers.dev URL
npm run typecheck   # optional: real TS type check (esbuild only strips types)
```

## Wiring the blog to the Worker

After the first deploy, set these in the site `_config.yml`:

- `comments_worker_url`: the Worker URL from `npm run deploy`.
- `turnstile_sitekey`: the Turnstile widget **site** key (public, goes in HTML).

## Local testing

```bash
cp .dev.vars.example .dev.vars   # fill in secrets for local runs (gitignored)
npm run dev
```
