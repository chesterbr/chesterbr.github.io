---
layout: post
title: 'Migrating blog comments from Disqus to Staticman'
og_image: /img/2024/02/staticman-logo-with-text.jpeg
description: "After years of using an external service for comments in my blog, I can now host and publish them alongside the posts, thanks to Staticman. Here's how I did it."
comments: true
---


![Staticman's logo by Erlen Masson (https://www.erlen.co.uk/), reproduced under a premise of fair use - a minimalist/negative space illustration of a Clark-Kent-y head and partial torso, but wearing a Superman-style cape, the cape tied with a bowtie. Below the text "Staticman", then "Static sites with superpowers"](/img/2024/02/staticman-logo-with-text.jpeg){: .left }

In this age of [controversial](https://www.engadget.com/how-twitter-died-in-2023-and-why-x-may-not-be-far-behind-143033036.html) social media platforms, having a [blog](https://en.wikipedia.org/wiki/Blog) is one of the few remaining opportunities to keep ownership over your content. There are several good solutions around to publish and host one, but [Jekyll](https://jekyllrb.com/) and [GitHub Pages](https://pages.github.com/) are a great (and free) combination for people like myself who are happy hacking a little bit - except for not providing a comment system out of the box.

For years, I filled that gap with [Disqus](https://disqus.com/) - a service that hosts your comments in exchange for a bit of advertising space. It was great at first, but over time [ads became heavier](https://disqus.com/home/discussion/channel-discusschitchatchannel/disqus_has_too_many_ads/), users were [pushed towards creating accounts](https://disqus.com/home/discussion/channel-discussdisqus/does_disqus_allow_anonymous_commenting/) and [abusively tracked](https://techcrunch.com/2021/05/05/disqus-facing-3m-fine-in-norway-for-tracking-users-without-consent/). Moreover, hosting comments externally affects search engine indexing, and over time this all caused people to comment less and less, so I decided to bring the comments back to my blog.

A comment system isn't a very complicated app, but it would be another database that I'd have to care for, and a departure from Jekyll's static generation model that served me so well. The ideal solution would be to store comments in the same place I store posts: a trusty GitHub repository. Jekyll can read data files to show the comments, and all I needed was to host an app somewhere that would create those files when a new comment is written.

I almost coded that app myself, but [Eduardo Bouças](https://eduardoboucas.com/about/) wrote and kindly shared [Staticman](https://staticman.net/), which does precisely that. Sure, I still had to host/configure it, adapt the blog to send it the comments (and read them from the repository files), and migrate the old comments from Disqus. These things combined took me a couple days, so I thought I'd share the process here.

<!--more-->

### Hosting Staticman

It's a good idea to first familiarize oneself with [how Staticman works](https://staticman.net/docs/), but the gist is that your blog's "new comment" form sends the POST to Staticman (instead of sending to the blog itself); Staticman has a GitHub API key that allows it to add the data file containing the post data to your website. That will trigger a rebuild (in the same way that a new blog post would), and Jekyll will show the new comment.

![A sequence diagram illustrating how the website (browser), the Staticman instance and the git provider (GitHub) interact: the browser POSTs a content submission to the Staticman, which grabs the config from GitHub, creates the pull request on it and sends back an OK response; once a merge happens, GitHub deploys the site with the newly submitted content](/img/2024/02/staticman-flow.png){: .center }

If you want to moderate the comments (like I do), it can create a pull request instead of merging the data directly. You review the pull request and merge it to approve, or discard to reject - a very familiar environment for most programmers these days. It supports other git providers such as GitLab, but I'll focus on GitHub.

You will need to host it somewhere. It's a lightweight, database-less Node.js app, so there are lots of options and not a lot of configuration involved. My choice is a DigitalOcean droplet (you can check my [recent blog post on cost-effective hosting](/archives/2023/11/budget-friendly-hosting-for-personal-projects) for details]).

The [official instructions](https://staticman.net/docs/getting-started) are clear once you figure the moving parts: your server will contain two RSA keys (a GitHub API key so the server can act on your behalf) and a private key that I suppose is used to store local secrets.

A few gotchas I ran into:

- There are two configuration files: the API configuration (`config.production.json`) and the site configuration (`staticman.xml`). The first contains secrets such as API keys and should only reside on your Staticman server; the other goes on your blog's repository, telling Staticman what to do when it receives a comment, and can be public ([here is mine](https://github.com/chesterbr/chesterbr.github.io/blob/b268fe58c6d0d1279c4c10031fa964ef2d3d19e3/staticman.yml)).

- The docs currently [state](https://staticman.net/docs/api#githubAppId) that the GitHub Application ID in `config.production.json` is `githubAppId`; actually, it's `gitHubAppID`.

- Both RSA keys were triggering [a `node-rsa` error](https://github.com/tngan/samlify/issues/452#issuecomment-1359699318). In order to fix it, I changed the code ([here](https://github.com/chesterbr/staticman/commit/bb2cc22e07fdf685751ee9d9758813af16f02f76) and [here](https://github.com/chesterbr/staticman/commit/6a52984c6273d59a7b9973fa8a11c6ff8faa77bd)).

- Thanks to GitHub's support for [Let's Encrypt](https://letsencrypt.org/), my blog runs over https (TLS), which means it [cannot post data to a regular http server](https://developer.mozilla.org/en-US/docs/Web/Security/Mixed_content). My go-to solution for those cases is to run the application behind [nginx](https://nginx.org/en/), configuring it to [terminate](https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-tcp/) the secure connection and use certificates that Let's Encrypt provides for free.

If you use Ansible (or are comfortable reading Ansible files), [here](https://github.com/chesterbr/chester-ansible-configs/pull/17/files#diff-5ed24083ba879c12fe8883c7c949333838832ee538935eaa3a3217e3ba5a328f) is the playbook that installs/configures the Staticman and nginx, with [Supervisor](http://supervisord.org/) to keep it running and [Certbot](https://certbot.eff.org/) to keep the certificates up to date.

### Creating and showing comments

At this point you should have a working Staticman server, so the next step is to add a form to your blog that sends the comment to it. The form should have the same fields that Staticman expects, and you can use JavaScript to send the data to the server and show the comment immediately after it's created.

I based mine on a few examples I saw online, most notably [this one](https://github.com/avglinux/alu-test-website). It uses [jQuery](https://jquery.com/) to send the data to the server and show the comment - not my choice in 2024, but I already have legacy JQuery code on the blog anyway, so I rolled with it.

You will know it is working when a post results in a pull request on your blog's repository like [this one](https://github.com/chesterbr/chesterbr.github.io/pull/29). Merging it will add the comment to your blog's `_data` directory, and the next step is to show it in the post's page.

Again I borrowed a lot from Avglinux's example, fixing a couple issues with the threaded replies and adjusting to my blog's style. I also replaced the Liquid [`strip_html` filter](https://shopify.github.io/liquid/filters/strip_html/) with [a custom one](https://github.com/chesterbr/chesterbr.github.io/blob/main/_plugins/sanitize_html.rb) that sanitizes it instead, so I can allow some HTML tags alongside the Markdown, while still keep the blog safe from JavaScript injection, [cross-site scripting attacks](https://owasp.org/www-community/attacks/xss/) and the like.

[This PR](https://github.com/chesterbr/chesterbr.github.io/pull/72) contains all the code mentioned above; feel free to peruse and copy any of the them; possibly checking the latest versions as this post gets older.

### Migrating comments from Disqus to Staticman

With this in place, all that was left to do was to migrate the comments from Disqus.

Disqus allows you to [export](http://disqus.com/admin/discussions/export/) the comments in an XML file (documented [here](https://help.disqus.com/en/articles/1717164-comments-export)), but in order to import them, a conversion is needed. I found a few recipes ([1](https://blog.arkey.fr/2022/10/16/moving-from-disqus-to-giscus/), [2](https://asp.net-hacker.rocks/2018/11/19/github-comments.html), [3](https://gist.github.com/evert/3332e6cc73848aefe36fd9d0a30ac390), [4](https://blog.riemann.cc/2021/12/27/jekyll-import-disqus-comments-for-staticman/)) online, but none of those worked for me, so I threw together [some JavaScript code](https://gist.github.com/chesterbr/6368adb7530f6d582046a5d93a4d4a49) that does the job:

{% gist 6368adb7530f6d582046a5d93a4d4a49 %}

You can just run it, making the needed adjustments for your `staticman.yml` configuration (e.g., if you changed the filename structure or added other fields that you want to import or generate) and put the generated `comments` directory under your `_data` directory in your blog's repository, like I did [here](https://github.com/chesterbr/chesterbr.github.io/pull/69/files).

The code documents some of the shenanigans I found (odd terminology, invalid characters, etc.). It's worth noticing that not every bit of information needed by Staticman is available in the XML, so a few trade-offs were made:

- I kept the comment `_id` as its original Disqus ID (instead of generating a UUID, which would change the values at each migration run and require an extra lookup for comment replies). Doing so made the `replying_to_uid` field odd, but it will correctly point to the `_id` of the comment being replied to, and Staticman is fine with that.

- `createdAt` is an [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) date with seconds precision, which is easy to convert to the `date` Staticman field (which is, by default, a [Unix time](https://en.wikipedia.org/wiki/Unix_time)), but the comment filenames are based on the timestamp in milliseconds. In order to improve uniqueness in the case of same-second comments, I filled the ms using the `_id` (once again keeping successive migration runs idempotent).

- My blog uses [Gravatar](https://gravatar.com/) to display user pictures (if they create one on the site; a generated pattern otherwise) based on a hash of their e-mail. Unfortunately, Disqus doesn't export users' emails, so instead of leaving it blank (which would give all users the same pattern), I hash the Disqus username, so the same user will always have the same pattern across the site.

### Conclusion

As I said before, it took me a while to figure out all these pieces, but I'm happy with how it turned out: I own the comments (which I can keep hosting if I ever switch away from Jekyll), they are indexed by search engines, and I can moderate them in a familiar environment (pull requests).

There is the burden/cost of hosting the server, but I share it with other apps, so it's effectively free for me. I did not (yet) set up email notifications for replies on users' comments or a spam filter, but that can be done with [Mailgun](https://www.mailgun.com) and [Akismet](https://akismet.com/) - and those services have generous free tiers.

The only caveat is that Staticman doesn't seem to be actively maintained, despite its numerous forks/users. That is a sign of maturity, but also makes me wary of yet-undiscovered vulnerabilities. But with its minimal code (and thus attack surface) and [Dependabot](https://docs.github.com/en/code-security/getting-started/dependabot-quickstart-guide) on my fork warning me about vulnerabilities found in its dependencies, I think it's worth the risk. Worst come to worse, it can always be replaced by a custom solution, since the comments are not locked in a proprietary system anymore - something I'll never give up again.
