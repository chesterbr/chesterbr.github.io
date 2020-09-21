---
layout: post
title: "Going from WordPress to Octopress"
comments: true
published: true
categories:
---

![I don't always write blog posts, but when I do...](/wp-content/uploads/2013/09/most_interesting_man_blog.jpg){: .center }

I could not express enough gratitude to the [WordPress][1] developers for offering the world a free, open-source, professional-quality blogging platform. Being based on a [LAMP][2] stack means it can be hosted pretty much anywhere with very limited resources, giving me freedom to change hosting services without any impact. Having a powerful admin panel, hundreds of plugins and being open to change means you can do pretty much anything with it.

One thing that I never liked, however, is the dynamic aspect: whenever you request a post, Wordpress has to retrieve information from a database, mingle it with HTML templates, call plugin code, build the page and *then* serve it. Surely, there are good caching plugins to alleviate the burden, but that is never as fast as plain old HTML. It also means there is software running on the server, which needs to be patched and catered.

[Octopress][3] has a more "back-to-the-basics" proposal: instead of running on your server, the software runs on your computer. Whenever you need to publish a new post, it generates the HTML pages for the whole site, then updates anything that changes. It is not a new approach, but its twist is that it uses tools that are familiar to modern web development, such as [git][4] and [Markdown][5].

The big challenge was migrating [12 years of blog posts][6] from Wordpress (some of them already migrated from other platforms and containing multiple flavors of horrible HTML). Octopress' built-in migration wasn't up to the task, but Ben Balter's [WordPress to Jekyll Exporter][7] did the trick - you just install it on your Wordpress, run the export and copy the result to the `source` folder. Done.

Of course I had to manually fix lots of small things - for example, all my YouTube/SlideShare embeds were broken, because they are based on `<iframe>` tags, which were not imported. But that is what weekends are for, and I am very happy with the final result.

Things like Twitter/Facebook/Google Analytics integration are already baked in - you only need to enter your credentials on the config file. Others (such as Facebook OpenGraph) can be [easily added][8] to the simple template structure. There are already a few [themes][9] available, but I found that some color adjustments on the standard one gave me a pleasant look - not to mention lots of improvements that were desperately needed on my former HTML, like [responsive design][10] and less blocking JavaScript.

There is still a lot to fix (such as [automating minification/joining of scripts and styles][11]), but I am amazed by the performance improvement, the convenience of using [GitHub][12] as storage and the abscence of security hassles. It is definitely **not** for the general public (you have to do lots of things manually, making a blogging service like [Blogger][13] or an easy-to-use software like WordPress more suitable for such an audience), but if you like to hack and feel comfortable with an Unix shell, git and plain text editors, Octopress is the way to go!

**UPDATE**: Forgot to mention that it won't handle comments. But it is easy to migrate them to [Disqus][14] (as usual, a [WordPress plugin][15] will do the trick), then just add the Disqus ID to the Octopress config file. Easy!

[1]: http://wordpress.org/
[2]: http://en.wikipedia.org/wiki/LAMP_%28software_bundle%29
[3]: http://octopress.org/
[4]: http://git-scm.com/
[5]: http://daringfireball.net/projects/markdown/syntax
[6]: /blog/archives/
[7]: https://github.com/benbalter/wordpress-to-jekyll-exporter
[8]: http://www.lukaszielinski.de/blog/posts/2013/01/28/twitter-cards-and-open-graph-metatags-in-octopress/
[9]: http://opthemes.com/
[10]: http://responsivedesign.ca/
[11]: http://www.eriwen.com/performance/make-octopress-fast/
[12]: https://github.com/
[13]: http://www.blogger.com
[14]: http://disqus.com
[15]: http://wordpress.org/plugins/disqus-comment-system/
