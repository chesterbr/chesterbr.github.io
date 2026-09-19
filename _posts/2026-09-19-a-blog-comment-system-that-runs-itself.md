---
locale: en
layout: post
title: 'A blog comment system that runs itself'
description: "Blog comments that live in my git repo, filter their own spam, and run on a tiny Cloudflare Worker instead of a server to babysit."
og_image: /img/spam-decision.png
comments: true
categories:
  - software
---

This blog is a quarter of a century old now (oh my! 👴), and for the better part of a decade it has run on [Jekyll](https://jekyllrb.com/): posts are just [Markdown](https://daringfireball.net/projects/markdown/) files in a repo, built to HTML and hosted for free - the comfort of a [Blogger](https://www.blogger.com/) or [WordPress.com](https://wordpress.com/), but with the same [VSCode](https://code.visualstudio.com/) and [git](https://git-scm.com/) I use for code, no ads, and nothing to lock me in.

The one part that never fit that model was comments. For years they meant a third-party system ([Disqus](https://disqus.com/), [Facebook Comments](https://developers.facebook.com/products/social-plugins/comments/)) with the usual ads, lock-in and spying - until [Staticman](https://staticman.net/) let me keep them in the repo too, as files, approved by merging on [GitHub](https://github.com/). I liked it enough to write a [detailed post](/archives/2024/02/migrating-blog-comments-from-disqus-to-staticman/) on setting it up.

Then the spam came, and Staticman couldn't stop it: its spam filter wouldn't connect, and with no updates in sight to fix that, its clever approve-by-merging turned into an unmaintainable chore. So I turned comments off and rethought the problem.

<!--more-->

## What actually needed replacing

At first I thought I'd have to throw everything away again to replace Staticman - until I realized it has three separate pieces: _storage_ (comment YAML files in the blog's git repository), _rendering_ (mostly built into Jekyll, since it supports yanking content from YAML), and _intake_ (the server that receives the form, filters spam, and writes the file). **Only the intake was broken.**

Writing, hosting and maintaining that intake server didn't sound practical. But it doesn't need to be a server: it's just a simple, stateless piece of logic behind an HTTP endpoint - a perfect match for a [serverless function](https://en.wikipedia.org/wiki/Serverless_computing), hosted nearly for free in a fire-and-forget fashion.

I chose [Cloudflare Workers](https://www.cloudflare.com/products/workers/) and had [Claude](https://github.com/anthropics/claude-code) help me build [that worker](https://github.com/chesterbr/chesterbr.github.io/blob/main/comments-worker/src/index.ts), which has just one job: to take an incoming comment and decide what to do with it.

## One job, in layers

[![How the worker works](/img/spam-decision.png){: .right width="280" }](/img/spam-decision.svg)

That "one job" is really a small pipeline. Cheap checks at the door kill most automated spam before it ever costs me a commit: a [honeypot](https://en.wikipedia.org/wiki/Honeypot_(computing)), a minimum fill time (a classic anti-bot heuristic - anything sent back in a second or two is almost certainly a bot), and [Cloudflare Turnstile](https://www.cloudflare.com/products/turnstile/) (an invisible CAPTCHA). What survives goes to [Akismet](https://akismet.com/) and then to [Claude Haiku](https://www.anthropic.com/claude/haiku) for a second opinion.

The verdict decides the comment's fate: clean ones publish themselves, disagreements open a pull request for me to review, and confirmed spam is dropped (but logged, so I can catch false positives). The approve-by-merging flow I loved in Staticman is still here, but now it only gets me involved when needed.

Security comes from that same simplicity: the worker uses a GitHub token of mine, scoped narrowly to this job and easy to disable or rotate if it's ever compromised. Nothing else.

A couple [GitHub Actions](https://github.com/features/actions) workflows keep it running without me. One [redeploys the worker](https://github.com/chesterbr/chesterbr.github.io/blob/main/.github/workflows/deploy-comments-worker.yml) whenever (and only when) I touch its code, so a dependency bump or a quick fix ships itself. The other two patch a blind spot: because the worker acts as me, GitHub never tells me about the comments it commits or the PRs it opens. So a separate workflow, running as a different actor, [assigns me the review PRs](https://github.com/chesterbr/chesterbr.github.io/blob/main/.github/workflows/notify-comment-pr.yml) and [leaves a note on the auto-published ones](https://github.com/chesterbr/chesterbr.github.io/blob/main/.github/workflows/notify-comment-push.yml) - and I hear about every new comment.

## Make it your own

I'd normally go into the details, or wrap it into a library - but it would likely hit the same maintainability walls Staticman did. So instead I just point at the script and its docs: skim those links (or hand this post to your AI assistant) and you can get something like it for your own site.

I'm very grateful to [Eduardo Bouças](https://github.com/eduardoboucas) for building Staticman - I could not have gotten to this point without his work and ideas. But I'm quite happy with what I have now, and hope everyone can also be!
