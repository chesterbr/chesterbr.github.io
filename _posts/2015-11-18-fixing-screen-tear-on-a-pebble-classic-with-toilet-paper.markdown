---
layout: post
title: "Fixing Screen Tear on a Pebble Classic With... Toilet Paper!"
date: 2015-11-18 22:57
comments: true
og_image: /img/2015/11/tearing.jpg
description: Just fixed my first-gen Pebble with this unusual choice of padding material.
categories:
---

The first-generation Pebble (now dubbed Pebble Classic) is, in my opinion, the best smartwatch in terms of cost/benefit. Unfortunately, a few of them start to manifest [screen tearing][1] after a few months of use, and mine was one of the "lucky" ones:

![](/img/2015/11/tearing.jpg){: .center }

At first, I thought it was a software issue, but the actual cause is that the screen connector does not cope well with the frequent vibration alerts. Such connectors are usually hard to fix/replace, but the gentleman on the [video][2] below realized that some pressure over the connector solved the issue. His ingenious choice of padding material caught my eye: small pieces of toilet paper!

<!--more-->

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/n7JBmktquUs" frameborder="0" allowfullscreen></iframe></center>

Since I had a tearing Pebble lying around, I decided to try the fix, which, amazingly, worked! It is likely not as waterproof as it was before, but I can live with that.

However, I ignored his warning about the vibration motor being glued to the back plate and attempted to do the padding without separating it. End result: I snapped the connections between motor and circuit board.

It wasn't *very* hard to re-solder the wires, but it took me a while to realize there was some thin layer of material (glue?) over the original soldering points. If you ever need to solder those wires back, first scratch the original solder with a non-conductive instrument, or the solder won't melt (or conduct anything).

Another interesting observation: if you short-circuit those points (yes, I did it a couple times) and the watch goes black, don't despair: just plugging the power would turn mine back on. It seems to have some protection against that. Just don't abuse it.

Of course, if you have this issue, you should first [contact Pebble][3]. I actually did it and got a replacement from them, and only tried this because they asked me to keep the faulty one.

[1]: https://forums.getpebble.com/discussion/10287/display-issues-screen-tearing-graphic-glitches-file-support-request-via-pebble-app
[2]: https://www.youtube.com/watch?v=n7JBmktquUs
[3]: http://help.getpebble.com/customer/portal/articles/1774495-screen-issues-?b_id=8515