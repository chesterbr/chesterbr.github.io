---
layout: post
title: "Connecting a classic (ADB) Apple keyboard to a modern (USB) PC using a regular Arduino"
date: 2016-12-27 05:00
comments: true
og_image: /img/2016/12/front.jpg
categories:
---

When I saw this person [building a Raspberry Pi inside a vintage Apple Keyboard][1], I thought it could be a comfortable way to play Apple II games on a TV. More important, I happen to have an [Apple Extended Keyboard II][8] just waiting for such an experiment...

![Keyboard + Arduino ](/img/2016/12/front.jpg){: .center }

My winter holiday plans did not include going outside, so I wanted to build it with parts I already had. But the hack uses an [Arduino Pro Micro][9] (with a little help of the [TMK Keyboard Firmware Collection][2]) as a converter between ADB (the interface used by the Apple II<small style="font-size: 75%">GS</small> and older Macs) and the familiar USB, and I only had a regular Arduino (actually, a [Leonardo][10]-compatible clone).

I wasn't sure that would do the job, so before tearing the keyboard apart, I decided that my first experiment would be an attempt to connect it to my computer.

<!-- more -->

To connect the Arduino to the keyboard, I could have cannibalized an [S-Video MiniDIN-4 cable][4], since ADB uses the same connector. But I ended up using [breadboard jumper wires][3], because they can be easily plugged on the Arduino *and* inserted straight into the ADB jack holes.

The [TMK ADB-USB wiring instructions](https://github.com/tmk/tmk_keyboard/tree/master/converter/adb_usb#wiring) suggest a pull-up resistor. I used a 6K8Ω (the first one I found within the recommended range) and a mini-breadboard to organize the connections. Here is how I wired it:

![Arduino-ADB connection with pull-up resistor ](/img/2016/12/adb_bb.png){: .center }

I wasn't sure which (if any) of the `.hex` files on the [`binary/` folder][5] would work, so I built my own. You can download it [here][7], or build (on a Mac with [Homebrew][6]) with:

```
brew tap osx-cross/avr
brew install avr-libc avrdude
git clone https://github.com/tmk/tmk_keyboard
cd tmk_keyboard/converter/adb_usb
```

At this point, edit the `Makefile`, changing `MCU` to `atmega32u4` and `TARGET` to `adb_usb_leonardo` (or any name you want), then:

```
make -f Makefile clean
make -f Makefile
```

![Keyboard + Arduino from behind  ](/img/2016/12/behind.jpg){: .center }

Now you should have a binary (`adb_usb_leonardo.hex`). To install it on the Arduino, use this command (pushing the RESET button on the board right before you hit ENTER):

```
sudo avrdude -patmega32u4 -cavr109 -P/dev/cu.usbmodemFD121 -b57600 \
  -D -Uflash:w:adb_usb_leonardo.hex:i
```

The device (`cu.usbmodemFD121`) may be a bit different for you (you can check the right name with the [Arduino IDE][11]). You will know it worked when you get a few progress bars, then something like `avrdude: 20528 bytes of flash verified`. At that point, the computer should "see" your Arduino as a USB keyboard.

It took me some time to figure out the build and install, but the hardware part worked without a hitch. With due apologies for the narration (I was pretty tired), you can see it in action here:

<p style="text-align: center;">
  <iframe width="640" height="360" src="https://www.youtube.com/embed/qT-lE_H3v2w?rel=0" frameborder="0" allowfullscreen></iframe>
</p>









[1]: http://straypoetry.com/project/raspberry-pi-inside-a-vintage-mechanical-apple-extended-keyboard/
[2]: https://github.com/tmk/tmk_keyboard/blob/master/converter/adb_usb/README.md
[3]: http://www.dx.com/p/breadboard-jumper-wires-for-electronic-diy-65-cable-pack-118826
[4]: https://www.adafruit.com/products/1380
[5]: https://github.com/tmk/tmk_keyboard/tree/master/converter/adb_usb/binary
[6]: http://brew.sh/
[7]: /download/adb_usb_leonardo.hex
[8]: http://lowendmac.com/2006/apples-extended-keyboard-ii-sequel-to-a-legend/
[9]: https://www.sparkfun.com/products/12640
[10]: https://www.arduino.cc/en/Main/ArduinoBoardLeonardo
[11]: https://www.arduino.cc/en/Main/Software
