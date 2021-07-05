---
title: 'Atari 2600 on a breadboard, part IV: clock + composite video = Hello, World!'
layout: post
og_image: /img/2021/07/hello-world-atari.jpg
description: "Some adventures with clock and composite circuits, but our baby now talks to the TV set!"
comments: true
categories:
---

In the previous post, I had the CPU, cartridge and TIA wired and tested, but still needed the Arduino to make them tick and check the resuts. All those hex numbers were fun to dbug, but let's get to the real deal: plugging it to the TV.
### Clock
In order to show the image of a game on a TV set, the video chip (TIA) needs to generate 60 frames (screens) per second, which, in turn, requires its clock to receive 3,579,545 "pulses" per second. What makes that magic work is a  [crystal oscilator](https://en.wikipedia.org/wiki/Crystal_oscillator), and fortunately that particular frequency (3.579545 Mhz) is so common in TV-related applications that one can easily [buy such a crystal online](https://www.walmart.ca/en/ip/3-x-3-579545-MHz-Crystal-Oscillator-HC-49S-Low-Profile/7DRO8USL2ETL).

The crystal won't do the job on its own. We need a circuit that amplifies and cleans the wave it produces, so the TIA gets a more regular signal. Each Atari 2600 model has a slight variation of that circuit, and after fiddling with a couple, I settled on the one used in the [Atari 2600 Jr.](http://www.atarimuseum.com/videogames/consoles/2600/atari2600jr.html), following this [diagram by Kevin Horton](http://www.kevtris.org/2600/2600schemo.html):

![](/img/2021/07/2600osc.gif){: .center }

![](/img/2021/07/clock-circuit-rough.jpeg)

Testing that circuit was a bit of a pickle: the Arduino could not monitor such a signal. Usually, these tests are done with an oscilloscope. Those appliances were always out of my budget as a hobbyist, but these days there are quite a few "USB oscilloscopes": they contain the electronics to do the measurement, but output their data to a computer, which makes them much cheaper. Professionals frown a bit on them, but the [Hantek 6022BE](https://www.amazon.ca/gp/product/B009H4AYII/) was within my price range, so I decided to give it a shot.

[![](/img/2021/07/oscilloscope-board-and-computer.jpeg)](/img/2021/07/oscilloscope-board-and-computer.jpeg)

It was a **great** purchase - in particular due to [OpenHantek](http://openhantek.org/), an open-source alternative to the included software that future-proofs the investment. The user guide initiated me to the point that I could measure the clock of a working Atari, then compare it with my circuit (click to zoom).

[![](/img/2021/07/clock.png)](/img/2021/07/clock.png)

In both cases, I got a steady wave, pulsing once each ~277ns, which the software computes to be a frequency of 3.60 Mhz. The actual values should be 279.365115ns and the 3.579545 Mhz mentioned above, but I had to mark the period manually, and this is as precise as I could get; maybe ther is a way for the software to auto-zoom on a single cycle, have to figure that out.

That was enough for me to organize and shorten the components into a tidier circuit. Notice the long horizontal cable connecting the clock output to TIA pin 11, where the Arduino used to provide a much slower pulse.

![](/img/2021/07/clock-final-with-tia.jpeg)
### Composite Video
At that point I had a clock that _probably_ puts the CPU/TIA to work in full speed, so now it's all about hooking it up to the TV, right? Not so fast: the TIA generates a few separate signals that need to be combined properly into a format that the TV can understand.

The Atari 2600 does so by generating an RF (antenna) signal, which was complicated, prone to interference and most modern TVs have a hard time with it, so a better option for modern TVs is [composite video](https://en.wikipedia.org/wiki/Composite_video). Roughly speaking, it combines a sync wave (that tells the TV when each frame starts) with the black-and-white and color components (aka "chrominance" and "luminance") of each pixel ([in a non-trivial](http://rfcafe.com/references/radio-news/color-tv-ntsc-system-radio-television-news-april-1954.htm) way to ensure backwards compatibility with black-and-white TVs).

[![](/img/2021/07/color-chart.png
)](/img/2021/07/color-chart.png
)

Modern-day Atari owners often install a "composite mod" on their consoles: a small circuit that extracts and combines the signals mentioned above from the Atari main board. I tried using [http://www.cheeptech.com/2600mods/2600mods.shtml](http://), but they all depend partially on existing components on the Atari board.

I found a [circuit](https://atariage.com/forums/topic/215414-composite-av-from-tia-chip/?do=findComment&comment=3065838) on the AtariAge forum (based on [a chroma/luma one from the Atari FAQ](https://www.atariage.com/2600/faq/index.html?SystemID=2600#composite)) that includes the Atari parts (the ones on the blue border). It's slightly more complex than others, but was the only one that generated  _anything_ on my TV.


[![](/img/2021/07/composite-circuit-from-parafin.png
)](/img/2021/07/composite-circuit-from-parafin.png
)

### Sync issues
Like I did on the previous post, I used the [Atari 2600 Hello, World program](https://gist.github.com/chesterbr/5864935) that I created for an [Atari 2600 Programming presentation](https://www.slideshare.net/chesterbr/atari-2600programming), because we still don't have RAM, timers or inputs that any regular game would require. Also, it's kinda fun to start with a "Hello, World".

My first attempt (which I [livestreamed in Portuguese](https://www.instagram.com/tv/CQoftoNF3zz/?utm_source=ig_web_copy_link)) was an epic failure (didn't check for shorts and smell of burning ensued), but the second one worked... _if_ you ignore the lack of color and the rolling screen 😅

<img src="/img/2021/07/scrolling.gif" alt="" class="center" style="width:700px; height:543px">

This often happens when Atari softare fails to "[race the beam](https://en.wikipedia.org/wiki/Racing_the_Beam)", but that piece of code is, to put it shortly, too minimalistic to fail. After checking the TV menus, I found the issue: the TV was recognizing the signal as PAL, and not NTSC.

Those systems [expect different frame sizes](https://www.spiceware.org/atari_ntsc_pal_secam.html), which explains the scrolling (the software sends the next screen starts before the TV is done with the previous one).

TVs of that time were electrical devices, driving a cathode tube that were tied to (among other things) the electrical frequency on the outlets (60Hz in countries that work with NTSC, 50Hz with PAL - which 100% relates to the 50 x 60 frames per second). If you used the wrong frequency, scrolling would indeed happen (if you want details, click the image for a great Technical Connections video about that):

[![this is a great video if you want the details](/img/2021/07/scrolling-person.jpg)](https://www.youtube.com/watch?v=l4UgZBs7ZGo)

In that context, my modern(ish) TV is more like an "emulator", trying to identify and decode the signal into its LCD array of fixed pixels. That is hit-and-miss (of the three TVs that I tested, this was the only one that showed any image at all). I tried adding a CD4050 chip as a buffer (like the [FAQ circuit](https://www.atariage.com/2600/faq/index.html?SystemID=2600#composite) does), no improvement.

### The fix => HELLO, WORLD!

What actually worked was "cleaning up" the circuit - cutting the components and fitting them properly (like I did with the clock). _That_ convinced the TV to recognize the signal as NTSC. Swapping the crystal also gave it more stability (maybe the livestream incident broke it? glad I bought a pack of 3 😅).

![](/img/2021/07/composite-final.jpeg)

Anyway, I **finally** got to the first milestone I envisioned where I started this journey, years ago: `HELLO WORLD`! 🎉

![](/img/2021/07/hello-world-atari.jpg)
### Next steps
Even with the fixed circuit, the image is a bit unstable, colors are wrong and there is an odd bar on the right. But instead of debugging these, I'll add the RIOT (the last chip), which should allow me to run actual games and fine-tune the circuit.

I also want to update the Fritzing sketches with all those circuits once I settle them (so anyone wanting to rebuild a custom Atari can have a more readable starting point), add or build a controller... we'll see!
