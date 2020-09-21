---
layout: post
title: "My Experience With PiScreen"
comments: true
og_image: https://farm8.staticflickr.com/7534/16019992942_1ea99dba61.jpg
categories:
---

Even though you can plug a Raspberry Pi to any modern TV/monitor, its diminutive size *screams* for a smaller screen, ideally a touch-sensitive one. PiScreen was one of the first (relatively) inexpensive screens like that. Excited by the video below, I backed [its KickStarter][1] in April, received it in October and just found the time to build it.

<p style="text-align:center"><iframe width="560" height="315" src="//www.youtube.com/embed/sM0-iksBXDc" frameborder="0" allowfullscreen></iframe></p>

I had some fun, and I will still do some interesting stuff with it. Some projects are more suited for it than others, so you may want to check my experience and decide whether it suits your needs.

<!--more-->

For [70 AUD][5] (55 + shipping) I got PiScreen in the "kit" form. Ten more bucks would have given me it fully assembled, but (as Steve Wozniak might say) why should I let someone else have the fun of soldering it? Even with a blue component among the orange/black ones (my kit was missing a 0.1 μF capacitor), the end result was a beautiful board, which can be either directly plugged above the Pi or connected with the (included) flat cable.

[![PiScreen after my soldering job ](/img/2014/12/pi1.jpg){: .center }](https://www.flickr.com/photos/chesterbr/15401048483)

Mind you, I had a few problems with the software. The [driver install instructions][7] are pretty clear, but I could not get the display to work, even on a freshly installed Raspbian. I had to use their [Linux image with drivers installed][8], which was good for testing and writing this post, but one would likely want to use the screen with other custom distributions (e.g., an emulator one like [ChameleonPi][9]).

It worked - but the colors were all wrong! Disappointed, I was ready to check my soldering (as it really seemed to be a hardware problem), but I discovered other people had the same problem, and the [solution][2] was to reduce the refresh rate of the screen. Not ideal, but it fixed the colors:

[![PiScreen with a flat cable, running Ruby (irb) ](/img/2014/12/pi2.jpg){: .center }](https://www.flickr.com/photos/chesterbr/16019991552)

The touch screen has a fair response - it is possibly more hindered by the Raspberry Pi itself (in particular on an unoptimized distro running X) than by its own build quality. I was able to play a reversi game with the included stylus, but a finger works fine for less precision-dependent tasks.

### Conclusion

[![PiScreen showing some windows ](/img/2014/12/pi3.jpg){: .right }](https://www.flickr.com/photos/chesterbr/15401045533)

Currently, you can buy the PiScreen in [assembled][3] or [kit][4] form. However, the KickStarter project creator [admits][10] the through-hole soldering increases the noise on the board, which requires the mentioned refresh rate reduction. It also seems that the GPIO connection driver will consume some Pi resources.

Those are surely deal-breakers if your goal is to play games or media - but for those applications, you'd rather drop the touch ability and get something with an HDMI/composite connection (which will work out of the box with any gaming distro with no performance penalty). People have been using [security camera][11] and [GPS rearview][13] screens to build [portable Raspberry Pi gaming consoles][12], which I may try at some point in the future.

[![PiScreen + Chocolate battery = yummy! ](/img/2014/12/pi4.jpg){: .center }](https://www.flickr.com/photos/chesterbr/16019992942)

However, other applications requiring touch support and not depending on high refresh rates on the screen are a great match for PiScreen. It is likely the most convenient, cost-effective and (why not) fun way to get a sturdy touch screen right over your Raspberry Pi.

[![PiScreen next to a card deck, for size comparison ](/img/2014/12/pi5.jpg){: .center }](https://www.flickr.com/photos/chesterbr/15834632689)



[1]: https://www.kickstarter.com/projects/2135028730/piscreen-a-35-tft-with-touchscreen-for-the-raspber
[2]: http://ozzmaker.com/forums/topic/wrong-colors-on-piscreen-my-raspberry-is-purple/
[3]: https://www.tindie.com/products/ozzmaker/piscreen-35-tft-with-touch-for-the-raspberry-pi/
[4]: https://www.tindie.com/products/ozzmaker/piscreen-35-tft-with-touch-for-the-raspberry-pi-kit/
[5]: http://www.google.com/search?q=70+aud
[7]: http://ozzmaker.com/piscreen-driver-install-instructions-2/
[8]: http://ozzmaker.com/piscreen/PiScreenImage-SDCard-1.6.zip
[9]: /archives/2013/03/raspberry-pi-with-berryboot-and-chameleonpi.html/
[10]: http://ozzmaker.com/forums/topic/wrong-colors-on-piscreen-my-raspberry-is-purple/#post-2930
[11]: http://www.dx.com/p/q1303-4-3-pal-ntsc-digital-security-tft-monitor-black-dc-12v-195293#.VI3OrKZrVf0
[12]: http://lifehacker.com/how-to-build-a-handheld-raspberry-pi-powered-game-cons-1663675758
[13]: http://www.amazon.com/gp/product/B00IUGW7PM
