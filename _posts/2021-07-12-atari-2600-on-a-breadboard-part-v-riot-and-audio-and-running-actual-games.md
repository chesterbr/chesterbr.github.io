---
title: 'Atari 2600 on a breadboard, part V: RIOT and Audio (and running actual games!)'
layout: post
og_image: "/img/2021/07/breadboard-with-riot-and-audio.jpeg"
description: "Image is still not great, but hey, I can hear Pac-Man dying \U0001F47B"
comments: true
categories: []
---

* [Part I: CPU (6507)](/archives/2017/09/atari-2600-cpu-running-on-a-breadboard/)
* [Part II: Cartridge](/archives/2021/02/atari-2600-on-a-breadboard-part-2-reading-a-cart/)
* [Part III: TIA (Video chip)](/archives/2021/06/atari-2600-on-a-breadboard-part-3-tidying-up-and-adding-the-TIA-video-chipe/)
* [Part IV: Clock and Composite Video](/archives/2021/07/atari-2600-on-a-breadboard-part-iv-clock-composite-video-hello-world/)
* Part V: RIOT (RAM, I/O, Timer) and Audio
* [Part VI: Joystick, switches, fixes and wrapping up](/archives/2021/09/atari-2600-on-a-breadboard-part-vi-fixing-the-video-adding-a-joystick-and-wrapping-up/)


### After Hello World

Now that I [got Hello, World! running](/archives/2021/07/atari-2600-on-a-breadboard-part-iv-clock-composite-video-hello-world/), I feel confident this project may actually succeed! 😅 The next step is to run an actual game, which requires wiring the last chip (and, due to the poor video I have so far, a sound circuit).

<!--more-->

### Adding RIOT
MOS's catalog included several support chips compatible with its successful 6502 "family" of CPUs (of which our Atari's [6507](https://en.wikipedia.org/wiki/MOS_Technology_6507) is a member). Atari picked the [6532](https://en.wikipedia.org/wiki/MOS_Technology_6532) to supply the missing pieces (**R**AM, **I**nput/**O**utput channels and **T**imers) that give this chip the nickname "RIOT".

Wiring it was no different than wiring the TIA. Pretty much:
- Following the address and data lines from the [schematics](/img/2021/06/schematics.jpg);
- Connecting the +5V (1) and ground (20) pins to their power rails;
- Bringing the RESET (34) pin up - the schematics have a 24K resistor _and_ a .1µF capacitor that I considered overkill, but heck, why not;
- Connecting the 6502 Phase 2 clock (𝜃2) clock and R/W pins (28 and 26) to its RIOT counterparts (39 and 35), so the CPU can sync the communication with the chip.

The chip also reads directional/fire buttons from joysticks, SELECT, START and both difficulty switches, but I'll wire those later. All I want is to give games what they need to run!

![](/img/2021/07/breadboard-with-riot-and-audio.jpeg)
### Some sound

Sound was actually part of TIA, but I did not bother adding it before because the only software I had that would work without RAM and Timers (the "Hello, World" program) was silent. But now it will work (and be invaluable since my composite output is still 💩), so I added a 1K resistor and a 1µF cap to both pins; resistor goes to 5V and cap goes to center pin of audio jack (outer part is ground). May be improved (e.g., doubling the circuit for "stereo" sound), but good for now.

### Games!
Incredibly, this setup worked first time (notwithstanding the video). One can hear (and almost see) Pac-Man going through the circle of life:

<iframe width="560" height="315" src="https://www.youtube.com/embed/Bag9FnKe2q0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
### Video blues

Unfortunately, I can't still get a good composite video image. Tried every composite circuit under the sun, results are still wonky. The best I got so far was with the circuit mentioned on the [last post](/archives/2021/07/atari-2600-on-a-breadboard-part-iv-clock-composite-video-hello-world/), only replacing a resistor that was a bit out-of-range:

![](/img/2021/07/pacman-so-so.jpg)

In fact, only one of my TVs got me any image at all (as previously mentioned, modern TVs are more picky with the signals they get). People often get around that running the signal through a VCR, but I had a much smaller option: this  [composite-to-HDMI converter](https://www.amazon.ca/Caxico-RCACVS-Composite-Converter-Blue-Ray/dp/B011E6GRPU). It's not as tolerant as the VCR (or a tube TV), but it picks up even this bad signal, and was quite cheap when I bought it.

![](/img/2021/07/upscaler.jpg)

### Next
I guess I should now add a joystick and SELECT/START (either a connector, or some push buttons, depending on what I have on my drawer), then fix the video (assuming it's not a TIA defect). Then I'll transcribe all the things back to a Fritzing drawing (so anyone - including myself in the future -  can reproduce), and I guess I will be done with this experiment.

* [Part VI: Joystick, switches, fixes and wrapping up](/archives/2021/09/atari-2600-on-a-breadboard-part-vi-fixing-the-video-adding-a-joystick-and-wrapping-up/)
