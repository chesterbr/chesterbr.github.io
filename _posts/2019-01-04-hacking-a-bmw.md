---
layout: post
title: "Hacking a BMW"
og_image: /img/2019/01/bmw-console-obd-slot.jpg
description: "I have zero interest in buying, driving or seeing cars. But *hacking* one, well..."
comments: true
categories:
---

My friend drives a [BMW 3 Series](https://en.wikipedia.org/wiki/BMW_3_Series_(F30)). Those cars come with a built-in entertainment system that allows you to connect your smartphone and make calls, which worked as expected. But some capabilities (which they call [Enhanced Bluetooth](https://www.youtube.com/watch?v=tBZFPzJadvI)) are only enabled by means of a "service fee" - even though you've already paid for the system.

And when "the man" abuses its power, hacking ensues...

<!--more-->

The car's [on-board diagnostics (OBD)](https://en.wikipedia.org/wiki/On-board_diagnostics) port can be used to configure all sorts of settings - as long as you have the proper equipment. Enter [BimmerCode](http://www.bimmercodeapp.com), a smart app that allows a smartphone to read/change those settings through an [OBD adapter](http://www.bimmercodeapp.com/adapter/) - a dongle that plugs into the port and connects to the phone via Bluetooth.

_**Fair warning**: there must be a dozen ways that you may render your car unusable by changing those settings (names suggest they affect things like the engine and fuel injection). Don't do anything unless you are confident **and** can afford to have the car towed and fixed by those same dealers that wanted to charge you for enabling the software in the first place..._

![Console OBD slot and dongle](/img/2019/01/bmw-console-obd-slot.jpg)

Once you pair the smartphone with the adapter and run the app, the fun comens in two flavours: a "basic" mode with high-level options, and an "expert" one that exposes all the low-level settings. We had to use the later, activating and applying two different config blocks (following [this helpful forum post](https://f30.bimmerpost.com/forums/showthread.php?t=1474066)):

```
HEADUNIT
  3003_Telefon_Telematik_Online
    - CDMM_Bluetooth_Audio
    - CDMM_BT_DATABASE
    - AUDIO_PLAYER_ON_OFF
    - BT_MODUL_ON_OFF
    - A2DP_PROFILE

COMIBOX
  3004_Bluetooth_Paramter
    - A2DP_AVRCP_EIN_AUS
```

We had to "restart" the car,  Windows-style (turning the ignition mode off and on again). Once we did, all the functions worked: browsing call lists, playing music (and controlling it from the car, even on a non-standard Android player app), Telegram calls and some other things.

![It snagged my call list...](/img/2019/01/contacts.jpg)
![...but played songs](/img/2019/01/music.jpg)

Best of all, the car still worked - a perfect wrap for an unusual New Year's hack! 😊
