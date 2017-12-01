---
layout: post
title: "Unbricking a WNDR3700v3 (NETGEAR N600) wireless router"
date: 2017-03-18 21:37
comments: true
categories:
---

![](/img/2017/03/wndr3700v3.jpg){: .right }

One day I decided to install an [alternative firmware][2] on my [NETGEAR N600][3] in order to tweak lower-level settings and try to minimize frequent (and very frustrating) disconnections on [Splatoon][1]. But the setup failed, effectively [bricking][4] the router.

"No sweat", I thought, "let me just put it into some sort of [recovery mode][5] and flash the original firmware into it". For this router, the idea would be to transfer the firmware via [TFTP][6] - which works by setting up a computer with [fixed TCP/IP configs][7] and starting the transfer at the right time during the boot process.

That didn't work either.

At that point, I realized this fix would require some physical hacking.

<!-- more -->

The idea was to connect a computer to the router via serial port and run some lower-level commands to restore the old firmware. But there was a catch: almost any decent router has a serial *port*, but very few have a serial port *connector*. To make the connection, I'd have to open the device and hook the computer's serial port to the [router motherboard pins][12] that contain the serial port signals (TX/RX/GND).

To make things *even worse*, mine doesn't have the pins, but just the holes on the board where they should be. Gee, thanks, Netgear! Tried soldering a header, but there was some gunk in one of the pins that I could not melt (they *really* don't want to make it easy), so I had to precariously keep them in place with a soldering "third hand".

Since each revision of the board has a slightly different pinout, I needed some multimeter peeking + trial-and-error to find the correct pin layout. Mine is the v3 and here is the setup that worked (green/6 = GND, blue/5 = RX, brown/2 = TX):

![Netgear N600 WNDR3700v3 serial pins ](/img/2017/03/router_pins.jpg){: .center }

Router connection solved, now to the computer side. Computers these days don't have serial ports - and even if they did, traditional (RS232) serial connectors are [electrically incompatible][13] with onboard serial circuits (TTL). Here are two possible workarounds:

- Use a [Raspberry Pi][9] by [configuring a pair of GPIO pins to operate as a TTL serial device][14];
- Get a cheap [TTL-level USB-to-serial converter][10] and plug it into any computer.

In any case, once you set up your terminal emulaton software with the proper parameters (115200/8/N/1), it should operate as a console to the router, so when you turn it on, you will see the boot messages of its Linux-based operating system:

```
Decompressing..........done
Decompressing..........done


CFE for WNDR3700v3 version: v1.0.6
Build Date: Wed May 18 17:25:10 CST 2011
Init Arena
Init Devs.
Boot partition size = 262144(0x40000)
Found an ST compatible serial flash with 128 64KB blocks; total size 8MB
et0: Broadcom BCM47XX 10/100/1000 Mbps Ethernet Controller 2010.09.30.0
CPU type 0x19740: 480MHz
Tot mem: 65536 KBytes

Device eth0:  hwaddr 2C-B0-5D-44-1A-1C, ipaddr 192.168.1.1, mask 255.255.255.0
        gateway not set, nameserver not set
Loader:raw Filesys:tftp Dev:eth0 File:192.168.1.2:vmlinuz Options:(null)
Loading: Failed.
Could not load 192.168.1.2:vmlinuz: Timeout occured
too long file.
LZMA boot failed
Loader:raw Filesys:raw Dev:flash0.os File: Options:(null)
Loading: .. 5192 bytes read
Entry at 0x80001000
Closing network.
Starting program at 0x80001000
Linux version 2.6.22.19 (root@tomato) (gcc version 4.2.4) #22 Mon Dec 5 07:45:34
 CET 2016
CPU revision is: 00019740
```
(snipped - full output [here][8])
```
eth0: Broadcom BCM47XX 10/100/1000 Mbps Ethernet Controller 5.110.27.20012
wl_module_init: passivemode set to 0x0
eth1: Broadcom BCM4329 802.11 Wireless Controller 5.110.27.20012
PCI: Enabling device 0000:01:01.0 (0000 -> 0002)
eth2: Broadcom BCM4331 802.11 Wireless Controller 5.110.27.20012
/ #
```

This shows Tomato (the custom firmware) is booting up (and possibly failing at some point), and we can see the TFTP daemon starting as well. I tried to use the output as guidance to do the timed TFTP trick, yet with no result. Having a root-y `#` prompt at the end allowed me to fool around a bit, but not to properly start the tftp daemon or change anything much useful.

I was about to give up, but [this page][11] shows the trick: during boot, you can quickly press `Ctrl`+`C` and get to a [Common Firmware Enviroment][15] `CFE>` prompt:

```
Decompressing..........done
Decompressing..........done


CFE for WNDR3700v3 version: v1.0.6
Build Date: Wed May 18 17:25:10 CST 2011
Init Arena
Init Devs.
Boot partition size = 262144(0x40000)
Found an ST compatible serial flash with 128 64KB blocks; total size 8MB
et0: Broadcom BCM47XX 10/100/1000 Mbps Ethernet Controller 2010.09.30.0
CPU type 0x19740: 480MHz
Tot mem: 65536 KBytes

Device eth0:  hwaddr 2C-B0-5D-44-1A-1C, ipaddr 192.168.1.1, mask 255.255.255.0
        gateway not set, nameserver not set
Startup canceled
CFE> ^C
CFE> ^C
CFE> ^C
CFE> ^C
CFE>
```

*That* shell allowed me to start `tftpd` manually. That instance would not time out, allowing the proper transfer of the firmware:

```
CFE> tftpd
Start TFTP server
Reading :: Done. 7258170 bytes read
Programming...done. 7258170 bytes written
Write len/chksum offset @ 0x006FFFF8...done.
Decompressing..........done
```

Once that process was finished, a reboot brought my router back to life, with the original system's boot message:

```
Linux version 2.6.22 (lawrence@foxconncpe2) (gcc version 4.2.3) #8 Sat Dec 14 13
:13:11 CST 2013
```

The [full output][9] of the original firmware suggests the CFE is not overwritten when a new firmware is flashed - meaning it will always be there as a last resource.

Of course, figuring all this took me a *very* long time. In the meantime, I had to get a new router, and I picked the [LinkSys WRT3200ACM][16] - a spiritual descendant of the WRT54G series that [started][17] the custom router firmware frenzy. Its beefed-up wireless specs guarantee consistent Splatoon matches. But it was quite fun to get "old" router back in working shape - and I learned a ton on the process!

[1]: http://splatoon.nintendo.com/
[2]: http://www.polarcloud.com/tomato
[3]: https://www.netgear.com/support/product/wndr3700v3
[4]: https://en.wikipedia.org/wiki/Brick_(electronics)
[5]: https://en.wikipedia.org/wiki/USB#Device_Firmware_Upgrade
[6]: https://en.wikipedia.org/wiki/Trivial_File_Transfer_Protocol
[7]: https://kb.netgear.com/22688/How-to-upload-firmware-to-a-NETGEAR-router-using-TFTP
[8]: https://gist.github.com/chesterbr/1ee3a231cd05a218f21c2582c142cf71
[9]: https://gist.github.com/chesterbr/95f57bf7bfc22e6c1bf81294813fe1ef
[10]: http://www.dx.com/p/pl2303hx-usb-to-ttl-converter-module-149859
[11]: https://forum.openwrt.org/viewtopic.php?id=47501
[12]: http://www.dd-wrt.com/phpBB2/viewtopic.php?p=889114
[13]: https://www.sparkfun.com/tutorials/215
[14]: http://elinux.org/RPi_Serial_Connection
[15]: https://en.wikipedia.org/wiki/Common_Firmware_Environment
[16]: http://www.linksys.com/ca/p/P-WRT3200ACM/
[17]: https://en.wikipedia.org/wiki/OpenWrt#History

