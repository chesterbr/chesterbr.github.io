---
layout: post
title: "Motion-sensing, Arduino-based Washing Machine Alarm"
date: 2017-12-22 22:00
og_image: /img/2017/12/w_alarm_final.jpg
description: "Soft end-of-cycle sound = wrinkled clothes. Arduino to the rescue!"
comments: true
categories:
---

I don't iron clothes. Heck, I don't even own an iron - [quickly folding clothes](https://www.youtube.com/watch?v=pLuuktlaqRU) _right when I remove them from the dryer_ works for most of them (and a [steamer](https://jiffysteamer.com/steamers/jiffy-esteam-handheld-clothes-steamer.html#156=20&166=58&158=25) does the job when that fails).

Problem: my current machine has a very low and short audio warning, so I often miss when it is done, ending up with wrinkled clothes. 😔

I thought it wouldn't be _too_ hard to build a device that detected when the machine stopped moving and alerted me in a more extravagant way. Having never played with raw accelerometers before, I would at least have some fun trying!

<!--more-->

This [instructables tutorial](http://www.instructables.com/id/Washer-Dryer-Laundry-Alarm-using-Arudino-SMS-Text-/) was a good starting point, but I had to change a few things:

- Instead of a power adaptor (requires a power outlet, not available near my dryer), I used a set of 4 AA bateries;
- To conserve battery power (and also to make it less bulky), I chose the Arduino Nano (actually, a [cheap clone](http://www.dx.com/p/nano-v3-0-atmega328p-development-board-for-arduino-blue-396797#.Wj2wQEtOl-U) I got for CAD$ 8 at Home Hardware)
- The Memsic 2125 accelerometer used for motion sensing on that tutorial is [a bit expensive](https://www.google.ca/search?q=2125+accelerometer&tbm=shop). A cheaper one like the [ADXL-345](https://www.aliexpress.com/item/GY-291-ADXL345-3-Axis-Digital-Gravity-Sensor-Acceleration-Module-IIC-SPI-transmission/32719111836.html?src=google&albslr=220871072&isdl=y&aff_short_key=UneMJZVf&source=%7Bifdyn:dyn%7D%7Bifpla:pla%7D%7Bifdbm:DBM&albch=DID%7D&src=google&albch=shopping&acnt=708-803-3821&isdl=y&albcp=658707750&albag=38901860132&slnk=&trgt=61865531738&plac=&crea=en32719111836&netw=g&device=c&mtctp=&gclid=Cj0KCQiA9_LRBRDZARIsAAcLXjdbyEECsmPLTqvmK4NpcmWuHlhdnFjX9B-KgS4IPn2pMNWbpJ-ycisaArn4EALw_wcB) does the job for CAD$ 4.50.
- Sending SMS is cool (and I'm considering something like that for an upgrade; see below), but requires expensive (and power-hungry) add-ons. For this first run, I used a (you guess - cheap) piezo speaker I had in my electronics drawer.

The piezo is easy to wire: (-) to Arduino GND, (+) to any Arduino digital pin (I chose pin 8). The accelerometer can be powered from the Arduino (connect their GND and 5V pins) and works out of the box with the [Arduino Unified Sensor Driver](https://github.com/adafruit/Adafruit_Sensor) if you connect the SDA and SCL pins to Arduino pins A4 and A5, respectively:

![circuit](/img/2017/12/w_circuit.png){: .center }

The on-off switch is actually built in my battery holder (which is AA, not AAA as in the illustration). It serves a dual purpose: saving power when the circuit is not in use, and providing a simple way to to turn the alarm off when I tend to the clothes.

[Tested](https://www.youtube.com/edit?o=U&video_id=DFl7gf34bgY) the idea using this prototype:

![prototype](/img/2017/12/w_prototype.jpg){: .center }

For the final version, I cut a piece of protoboard to the right size, soldering jumpers for the connections:

![front_and_back](/img/2017/12/w_front_and_back.jpg){: .center }

Yes, I used random pieces of wire from the magic drawer. The different colors are ugly, but make connections easy to check. I fixed the board on the battery holder with Durepoxi (a magic plastic adhesive I had to bring from Brazil - if you ever find it for sale online or in Toronto, _please_ let me know).

![Durepoxi](/img/2017/12/w_durepoxi.jpg){: .center }

The final result was not too shabby:

![alarm final](/img/2017/12/w_alarm_final.jpg){: .center }

The software checks the accelerometer every few seconds (putting the board in full sleep between checks), and sums the change in acceleration for each of the axis (x, y and z). If that sum is greater than a given value, the device is considered to be moving.

Once we get a certain number of "not moving" consecutive measurements, we decide the dryer has stopped shaking it, and trigger the sound. That's it.

<script src="https://gist.github.com/chesterbr/9d682b11715c092793b848977ebd8dac.js"></script>

The values of `MOTION_SENSITIVITY` and `MEASUREMENTS_TO_CONSIDER_STOPPED` were tweaked to match my dryer.

As-is, the code will just play an annoying beep, but you can replace the `play_music()` function with anything. For example, I threw a [MIDI file with the Animaniacs opening theme](http://cartoons2006.tripod.com/id8.html) into a [MIDI To Arduino Code](https://extramaster.net/tools/midiToArduino/) converter. Here is the result (as I manually turn the machine off):

<center><iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/2yiWkEmelA0" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe></center>

I'm happy with how it turned out, but there is room for improvement:

- The power consumption can be reduced by disabling one or both the LEDs and tweaking with power regulation, but that requires [cutting the board](http://www.home-automation-community.com/arduino-low-power-how-to-run-atmega328p-for-a-year-on-coin-cell-battery/), which I'm not in the mood for - _yet_.
- What if I'm wearing headphones? I wish I could trigger Google Home (currently [hard](https://productforums.google.com/forum/#!msg/googlehome/g9xb-uRqEz0/ae_6OKL2CQAJ)), or maybe play a sound on my computer. If I can come with something not too power-hungry or overcomplicated to make that, I guess I'll tinker with this again...
