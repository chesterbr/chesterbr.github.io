---
title: Cosine of a Heart
excerpt: |
  |
    Useless is one of my favorite xkcd installments: Useless (xkcd), by Randall Munroe - some rights reserved This is obviously an useless approach, but it's hard for a math undergrad to see so many question marks! The second equation, in...
layout: post
comments: true
permalink: /archives/2009/04/cosine_of_a_heart.html/
robotsmeta:
  - index,follow
dsq_thread_id:
  - 1751450163
categories:
---
[Useless][1] is one of my favorite [xkcd][2] installments:

<p style="text-align:center">
  <a href="http://xkcd.com/55/"><img title="Even the identity matrix doesn't work normally" src="http://imgs.xkcd.com/comics/useless.jpg" alt="Useless" border="0" /></a><br /> <small>Useless (xkcd), by Randall Munroe &#8211; <a href="http://creativecommons.org/licenses/by-nc/2.5/">some rights reserved</a></small>
</p>

This **is** obviously an useless approach, but it&#8217;s hard for a math undergrad to see so many question marks! The second equation, in particular, got me thinking for quite a while:

<center>
  <em>cos ♥ = ?</em>
</center>

How could someone extract the cosine of a heart? It seems impossible &#8211; unless you can represent a heart in mathematics. And I remembered a very interesting curve from calculus that might be a candidate for that: the [cardioid][3]. Its name implies some relationship with a heart shape. I was never much sold on that, but you can judge by yourself:

<span class="mt-enclosure mt-enclosure-image"><img class="mt-image-center" style="text-align: center; display: block; margin: 0 auto 20px;" src="//chester.me/archives/img/mt/2009/03/14/cardioid.jpg" alt="cardioid.jpg" width="349" height="289" /></span>

It may not be the best heart representation ever seen, but at least it is described by a very simple formula &#8211; if you don&#8217;t mind using [polar coordinates][4]:

<center>
  <em>ρ = 1 &#8211; sin(θ), θ ∈ [-π π]</em>
</center>

If you change the signal from minus to plus and/or the function from *sin* to *cos* you can change the orientation of the graph. As it is, it may fit our plans, except for two problems:

*   The top does indeed look like the upper part of a heart symbol, but the bottom is a bit frustrating in that sense;
*   You still can&#8217;t calculate the cosine of a polar curve (at least, not in a graphically meaningful way).

We can tackle the first problem by replacing the bottom of the curve. First we draw just the part that fits our heart&#8217;s desire for a heart, that is, the one with *θ ∈ *[*-(1/3)π, (4/3)π*]:

<span class="mt-enclosure mt-enclosure-image"><img class="mt-image-center" style="text-align: center; display: block; margin: 0 auto 20px;" src="//chester.me/archives/img/mt/2009/03/14/cardioid_upper.jpg" alt="cardioid_upper.jpg" width="349" height="289" /></span>

Now we can add a second curve that fits the remaining part with the more traditional sharp edge. But first let&#8217;s convert the formula to its cartesian equivalent, using the definitions: *x(θ) = ρ.cos(&#952;)* and *y(θ) = ρ.sin(&#952;)*. Then we have, for *θ ∈ *[*-(1/3)π, (4/3)π*]:

<center>
  <em>x(θ) = cos(θ)-cos(θ)sin(θ)<br /> y(θ) = sin(θ)-sin<sup>2</sup>(θ)</em>
</center>

Making a &#8220;tip&#8221; on the bottom requires *x* to vary on the range between the two loose edges on the graph, and y is just a straight line going down then up &#8211; the modulus function will help us. But doing so using the same &#952; parameter on the complimentary range (from *(4/3)π to -(1/3)π*) requires a few substitutions and manipulations to put everyting in place. It gets like this:

<center>
  <em>x(θ) = (&#952;-(9/6)π).(6/π).(cos(4π/3)-cos(4π/3)sin(4π/3))<br /> y(θ) = 2|(&#952;-(9/6)π)|+sin(4π/3)-sin<sup>2</sup>(4π/3)-π/3</em>
</center>

Yes, it can be simplified, but I&#8217;m too <span style="text-decoration: line-through;">lazy</span> focused on the main problem now. The resulting graph is:

<span class="mt-enclosure mt-enclosure-image"><img class="mt-image-center" style="text-align: center; display: block; margin: 0 auto 20px;" src="//chester.me/archives/img/mt/2009/03/14/heart_lower.jpg" alt="heart_lower.jpg" width="349" height="260" /></span>

which fits nicely into the top part:

<span class="mt-enclosure mt-enclosure-image"><img class="mt-image-center" style="text-align: center; display: block; margin: 0 auto 20px;" src="//chester.me/archives/img/mt/2009/03/14/heart_full.jpg" alt="heart_full.jpg" width="349" height="260" /></span>

The conversion to cartesian formulas also solves the other problem: it is reasonable to think that the cosine of a system of equations is obtainable by applying the cosine function to each of the equations &#8211; you can think about that either as applying the cosine to each coordinate of each point, or as doing that to the equations in matrix form. Or you can just use your heart and believe when I say it&#8217;s reasonable. Your call.

Anyway, by applying the cosine to the formulas above, we obtain the following graphic, **which represents cos(♥)**:

<span class="mt-enclosure mt-enclosure-image"><img class="mt-image-center" style="text-align: center; display: block; margin: 0 auto 20px;" src="//chester.me/archives/img/mt/2009/03/14/cosine_of_a_heart.jpg" alt="cosine_of_a_heart.jpg" width="349" height="260" /></span>

The most frustrating part is that it&#8217;s not a closed curve &#8211; one might imagine a line linking the two edges and try some [rorschach][5]-esque interpretation (a friend of mine suggested a sillhuete of a female bust, but his heart was under heavy stress at the moment). Another interpretation is to realize that you simply end up with a broken, deformed heart (which **is** what happens after you find out that math is all you have left to deal with issues in your life).

<span style="text-decoration: underline;"><strong>Epilogue</strong></span>: The same techinque could be applied to the other formulas, which is, [as usual][6], left as an exercise to the reader. A few pointers:

*   The identity transformation looks trivial, but that is not acceptable (check the tooltip on the comic);
*   Formulas that already treat the heart as a function (such as d/dx) can possibly be applied in a more straightforward way;
*   Munroe seems to have replaced the Fourier transformation with a Laplacian on the [comic&#8217;s t-shirt][7]. Heck, work is [never over][8]!

&nbsp;

 [1]: http://xkcd.com/55/
 [2]: http://en.wikipedia.org/wiki/Xkcd
 [3]: http://en.wikipedia.org/wiki/Cardioid
 [4]: http://en.wikipedia.org/wiki/Polar_coordinate_system
 [5]: http://en.wikipedia.org/wiki/Rorschach_inkblot_test
 [6]: http://abstrusegoose.com/12
 [7]: http://store.xkcd.com/xkcd/#Useless
 [8]: http://www.youtube.com/watch?v=K2cYWfq--Nw
