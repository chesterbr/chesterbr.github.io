---
title: Tweet xkcd bookmarklet
excerpt: |
  |
    Since people love to post their favorite xkcd strips on Twitter, I thought this might help: drag the link below onto your links toolbar (it will create a button). Whenever you read an xkcd comic you want to share, just...
layout: post
comments: true
permalink: /archives/2009/04/tweet_xkcd_bookmarklet.html
dsq_thread_id:
  - 1751448816
categories:
---
Since people love to post their favorite [xkcd][1] strips on [Twitter][2], I thought this might help: drag the link below onto your links toolbar (it will create a button). Whenever you read an xkcd comic you want to share, just click the button: it will use the &#8220;secret message&#8221; text (cutting words to fit 140 chars, if needed) to produce a nice tweet about the strip that you can review and send directly from your Twitter home page:

<p style="text-align: center;">
  <a href="javascript:(function(){var%20c=document.images;tv='';for(var%20i=0;i<c.length;i++){t=c[i].title;if(t&&(t!='')){tv=t;break}}l=location.href;h='';if(tv!=''){while(tv&&(l.length+tv.length+4>140)){tv=tv.match(/.*\s/);if(tv){tv=tv[0].substring(0,tv[0].length-1)};h='...';}location.href='http://twitter.com/home?status='+tv+h+'%20'+l;}else{alert('No%20xkcd%20strip%20found')}})();">Tweet xkcd</a>
</p>

<div style="text-align: left;">
  <small>(if you are using IE6, right-click, add to favorites, select links bar, then ok. Or do yourself a favor and switch to <a href="http://getfirefox.com">Firefox</a>.)</small>
</div>

Feel free to [tweet about this][3] or [send me feedback][4]!

 [1]: http://xkcd.com
 [2]: http://twitter.com
 [3]: http://twitter.com/home?status=Use%20this%20bookmarklet%20to%20tweet%20xkcd%20comics%20easily%20(by%20@chesterbr):%20http://tinyurl.com/tweetxkcd
 [4]: http://twitter.com/chesterbr