---
layout: post
title: "Building a classic XBox to USB adapter (to use a RedOctane Ignition DDR mat to a computer)"
og_image: "/img/2020/07/box-final.jpg"
description: "This is the best DDR pad you could have back in the days. With some wiring, the groove continues in 2020!"
comments: true
categories:
---

As a [Dance Dance Revolution (DDR)](https://en.wikipedia.org/wiki/Dance_Dance_Revolution) enthusiast on its heyday, I spent a lot of time [adapting dance pads](https://chester.me/tapete/) to improve comfort and durability, until I [got myself an Ignition pad](https://chester.me/ignition/). Its thick rubber interior, superior sensors and [RedOctane](https://en.wikipedia.org/wiki/RedOctane) (of Guitar Hero fame) quality resulted in no mis-/over-/continued registering of arrows, less knee strain and happier downstairs neighbours.

![My Ignition pad from the 2000s](/img/ignition/tapete.jpg){: .center }

I sold that one years ago, but having some floor space and time now, I decided to buy a "new" one on eBay. Not having a Playstation these days, I planned to use [Stepmania](https://www.stepmania.com/) (the open-source DDR clone), but my mat was missing the USB adaptor. A Playstation-to-USB one gets recognized, but [arrows do not register correctly](https://www.reddit.com/r/DanceDanceRevolution/comments/40k6y0/looking_for_a_red_octane_dance_pad_usb_breakaway/cywo6rs/).

The adaptor I needed would plug in the XBox connector ([classic XBox controllers](https://en.wikipedia.org/wiki/Xbox_controller) are quite close to USB in nature, as we'll see below). They are near-impossible to find, but it seems the breakaway cable that came with the controller can be converted into such an adaptor.

<!--more-->

<iframe width="700" height="393" src="https://www.youtube-nocookie.com/embed/Zt-6FxZqgYQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The operation is trivial:

- Buy [the XBox controller breakaway cable](https://www.ebay.com/itm/192880300626);
- Get any USB data cable (you likely have a dozen in your drawer);
- Split both cables, getting the round end of the first and the USB-A end of the other (the ones that plug on the mat and on the computer);
- Just connect the wires, matching the colors on each side (it seems the classic XBox controller is a USB device, just with a different plug - even the cable colors follow [the standard](https://hubpages.com/technology/USB-wire-color-code-The-four-wires-inside)).

![color-matched wires between XBox controller and USB connectors](/img/2020/07/ends-wired.jpg){: .center }

I was going to solder them together and tape (like the video), but it seemed too flimsy for me, so I soldered the wires into a protoboard, then fixed the set on a small box with my trusty [Durepoxy](https://www.supermarketbrazil.com/products/brazilian-original-epoxi-durepoxi-solder-henkel-adhesive-paste-100g-loctite).

![Durepoxy is great. And nowhere to be found in Canada. It is likely a health hazard](/img/2020/07/protoboard-on-box.jpg){: .center }

Ugly, I know, but sturdy. Once the box was closed, had some cleanup and electrical tape finished, it looked much better:

![Noice](/img/2020/07/box-final.jpg){: .center }

As for the software, I used this [macOS XBox Controller Driver](https://sourceforge.net/projects/xhd/). To test it (and Mac controllers in general), I recommend [Controllers Lite](https://apps.apple.com/ca/app/controllers-lite/id673660806?mt=12):

![Controllers lite - my adaptor works \o/](/img/2020/07/controllers-lite.png){: .center }

With that set, I downloaded [Stepmania](https://github.com/stepmania/stepmania/releases), addded some songs from the usual places, and spent a great afternoon playing! 🕺

!["Let's MAX, I mean... who do you verb Stepmania?"](/img/2020/07/mat-and-stepmania.jpg){: .center }

P.S.: If you can't find the original XBox breakaway cable, [this page](https://www.instructables.com/id/Clean-and-EASY-convert-original-Xbox-controller-to/) says an XBox 360 one (which is already USB on the other end) will do, as long as you sand the connector a bit to make it fit on the mat/controller. I'm curious to try that.
