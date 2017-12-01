---
title: u.nu URL shortener bookmarklet
layout: post
comments: true
permalink: /archives/2010/02/u-nu-url-shortener-bookmarklet.html
robotsmeta:
  - index,follow
onswipe_thumb:
  - SKIP
categories:
---
<p style="text-align:center;font-style:italic">
  Unfortunately, u.nu ceased to exist as an URL shortener,<br /> but I decided to keep the article as a curiosity.
</p>

A URL shortener like [TinyURL][1] or [bit.ly][2] is a handy tool on these Twitter times. But even shortened URLs from those services can get a bit too long when you are on tight spots.

Enter [u.nu][3], arguably the shortest URL shortener in town &#8211; which, unfortunately, does not come with a one-click shortening option like bit.ly&#8217;s bookmarklet. It **does**, however, offer an API, with which I quickly hacked a minimalistic bookmarklet.

Just drag and drop the link below to your browser and turn anything in your browser into a short URL with a single click:

<p style="padding-left: 30px">
  <em><a href="javascript:location.href="&#39;http://u.nu/unu-api-simple?url=&#39;+escape(location.href);"" id="a_unu">u.nu</a> <- drag <strong>that</strong> to your browser&#8217;s toolbar.</em>
</p>

**UPDATE**: Real stupid mistake &#8211; forgot to escape the URL (but hey, I told it was a quick hack :-P ) &#8211; fixed now (Feb 9, 2010).

 [1]: http://tinyurl.com
 [2]: http://bit.ly
 [3]: http://u.nu