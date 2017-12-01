---
title: Should GMail blacklist spam senders?
layout: post
comments: true
permalink: /archives/2013/08/should-gmail-blacklist-spam-senders.html
robotsmeta:
  - index,follow
dsq_thread_id:
  - 1751448303
categories:
---
My friend [FZero][1] said today on Facebook:

> Dear GMail: when I mark something as spam, you should BLOCK that email address from ever sending me anything again.

and my answer got a bit too long for Facebook, so here it is:

*[TL;DR: Statistics say it would not work well for everyone, but might work for you, but Google is about large data sets, not (directly) about you, so if you want it, [hack the planet][2]!]*

I&#8217;m not really up-to-date on the subject, but let&#8217;s assume the core of what GMail does behind the scenes is still a well-balanced &#8220;naive&#8221; [Bayesian probabilistic approach][3] for &#8220;spam/unsure/ham&#8221; classification (possibly fine-tuned by Google&#8217;s secret sauce of massive data analytics).

I remember (but can&#8217;t find right now) follow-ups to Paul Graham&#8217;s [original work][4] (which kickstarted the technique from a statistical indicator into a &#8220;99%+&#8221; efficient spam filtering technique) pointing to data/reproducible experiments suggesting that most &#8220;field knowledge&#8221; applied to the data sets (like, for example, bumping the significance of the From email address) of specific email tokens did not improve the efficiency metrics, and in several cases did indeed **decrease** efficiency.

However, a core point was that the inclusion of headers both in the both the database scoring and the composed score for each message (along with [careful tuning of token identification][5] to improve token database hit ratio) \*did\* improve the efficiency of the classification, so there \*may\* be some gain into applying unequivocal domain knowledge into the \*classification\* (i.e., doing exaclty what you say), as long as it doesn&#8217;t update the token scores with such blacklisted e-mail bodies (to avoid aforementioned performance decreases) \*and\* the blacklisted-to-normal spam messages frequency is low enough that their removal from the process does not decrease significantly the corpus of analyzed messages.

To add (yet) more opinionated guesswork, I&#8217;d say that Google products in general tend to lean more towards deriving behavior from large data set analysis rather than gut feeling, so I think it is very unlikely they will consider the suggestion. Would not surprise me, however, if they haven&#8217;t already A/B tested that (and every other algorithmic variation under the sun).

But I&#8217;ll finish this random rumble with at least one assertive comment: you could do it on your own by creating a blacklist filter &#8211; in fact, maybe a browser plugin (or something talking to the [API][6]? never looked it to omuch) could trick the spam button into also adding the sender to such a filter. Looks like an interesting hack to try&#8230;

 [1]: http://fzero.ca/
 [2]: http://www.youtube.com/watch?v=drJWxMLrpE0
 [3]: http://en.wikipedia.org/wiki/Bayesian_spam_filtering
 [4]: http://www.paulgraham.com/spam.html
 [5]: http://www.paulgraham.com/better.html
 [6]: https://developers.google.com/gmail/