---
layout: post
title: "Renovating an Atari 2600 (AV mod + capacitor/power adaptor replacement)"
date: 2019-02-18 12:10
og_image: /img/2019/02/atar.jpg
description: "Giving this venerable dark beauty a bit of love for improved audio, video and fun."
comments: true
categories:
---

A while ago I got this beautiful Atari 2600 all-black, 4-switch model - often nicknamed "Darth Vader", for obvious reasons:

![](/img/2019/02/atari.jpg){: .center }

The console generates a TV signal, which the TV has to tune in just like a normal over-the-air channel. It was quite convenient at the time (and quality was good enough for the TV sets we had), but modern TVs show degradation - not to mention some can't even pick up the faint signal - I [had to hook mine to a VCR]({% link _posts/2014-10-22-it-was-easy-to-plug-this-atari-dot-dot-dot.markdown %}) that would decode the signal into A/V.

That quirky setup led me to make the popular A/V conversion ("mod") - and, while at it, replace the power adaptor (with one that I can actually keep on the wall without fear of burning down the house) and capacitors (something that [should be done](https://antiqueradio.org/recap.htm) to any vintage electronics that you want to keep humming).

There are [different types](http://www.cheeptech.com/2600mods/2600mods.shtml) of of mods, varying in how they mix (or split) the video and audio signal and what sort of output they generate. I opted to get an A/V output from the signals mixed by the Atari board (but before they get modulated into a TV signal), with the video one amplified by a single transistor and a couple resistors.

I based my mod on [this version](http://blog.tynemouthsoftware.co.uk/2015/02/atari-2600-composite-video-modification.html), which throws in a third 75Ω resistor that adjusts the impedance. Following the schematics there, I aligned the components like this (transistor is a 2N3904, flat side up; resistors are, from left to right, 75Ω, 3K3Ω and 2K2Ω):

![](/img/2019/02/av-mod-schematics.png){: .center }

There are ready-made circuit boards, but I just cut a piece of protoboard. Hint: don't solder the cables like I did - instead, follow the "strain relief" tip [here](https://makezine.com/2015/10/15/how-and-when-to-use-protoboard/) for better securing.

![](/img/2019/02/av-mod-front.jpg){: .center }

The layout reduced the number of connections, so I could just throw an extra gob of solder over the terminals before cutting to make them. Maybe I could have used a little _less_ solder, but heh, it worked.

![](/img/2019/02/av-mod-back.jpg){: .center }

You need to pick up Video In signal and the +5V/GND from the Atari board. Mine was a Rev 16, which has those three right on the connector of the RF box. That box had to be removed anyone - but totally worth it for freeing some space to put the board on.

![](/img/2019/02/audio-out.jpg){: .center }

Audio comes straight from the Atari board into the inner part of the audio jack. I strongly recommend checking [this PDF mod assembly guide](http://www.coolretroprojects.com/Atari_2600_AV_Mod_Installation_Guide.pdf) to figure out where to pick it up in your particular model/board revision.

![](/img/2019/02/av-rear-connectors.jpg){: .center }

The guide also helps figuring out which components to remove in order to reduce interference. I was able to test before removing anything from the board (just disconnected the RF box, something easy to revert if it did't work). I just removed one resistor (R209) and one transistor (Q202).

This is a good moment to replace the capacitors. Again, each model has its own set, but [this thread](http://atariage.com/forums/topic/262206-cap-and-vr-kit-specifications-replacement-locations-for-the-2600-variants/) has it figured out. I could not find a bulky C243 (guess the technology for eletrolytics improved), but stretching the legs on the modern one allowed me to solder it.

![](/img/2019/02/atari-board-with-mod.jpg){: .center }

You can find a lot of Atari 2600 [power brick replacements](https://www.amazon.ca/Childhood-Supply-Adapter-System-Portable/dp/B01N5G4RX0?SubscriptionId=AKIAILSHYYTFIVPWUY6Q&tag=duc12-20&linkCode=xm2&camp=2025&creative=165953&creativeASIN=B01N5G4RX0) online. But most of them have short cables, so I reused the original's loooong cord on [a high quality 2A power supply](https://www.creatroninc.com/product/9v-2a-switching-power-supply/)) with the proper [adapter](https://www.creatroninc.com/product/1mm-dc-barrel-m-to-terminal-adapter/). Just ensure that it supplies 9V and a minimum of 0.5A with polarity [as labeled on the original](https://dfarq.homeip.net/atari-2600-power-supply-specs/) (⊖-outside, ⊕-inside).

The most unexpected improvement was in audio quality. Even without a second audio jack, I get **much** better sound now that what I had with RF. Image has almost no artifacts now (it seems the occasional faint vertical line/shadow [is a fact of life](http://atariage.com/forums/topic/266659-blue-vertical-lines-on-2600/) unless you go with [more sophisticated mods](http://electronicsentimentalities.com/Assembled%20Mods.html).

Personally, I'm pretty happy with the results I got:

![](/img/2019/02/pacman.jpg){: .center }
![](/img/2019/02/seaquest.jpg){: .center }
![](/img/2019/02/space-invaders.jpg){: .center }

My friends were also super happy:

![](/img/2019/02/happy-friends.jpg){: .center }

One of them got enough points in Frostbite to [earn an Activision Patch](http://www.atariage.com/2600/archives/activision_patches.html) 😁. Too bad we are a few decades late to send a picture to Actvision, but here are the proof and her honorary patch.

![](/img/2019/02/frostbite-patch-record.jpg){: .center }

![](/img/2019/02/frostbite-patch.jpg){: .center }
