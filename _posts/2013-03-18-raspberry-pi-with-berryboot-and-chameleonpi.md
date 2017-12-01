---
title: Raspberry Pi (with BerryBoot and ChameleonPI)
layout: post
comments: true
permalink: /archives/2013/03/raspberry-pi-with-berryboot-and-chameleonpi.html
robotsmeta:
  - index,follow
dsq_thread_id:
  - 1751447743
categories:
---
*(TL;DR: if you just want to know how to make ChameleonPI v0.3 work with BerryBoot, jump [here][1])*

### My Raspberry PI

The Raspberry Pi is a low-priced small computer-in-a-board, built for those who want to tinker, learn and have some geeky fun. The overall experience is quite reminiscent of the hobbyist 8-bit personal computer age &#8211; it may be more than a coincidence that the project shares British origins with the Sinclair ZX81/Spectrum and the BBC Micro.

Like many of today&#8217;s smartphones and low-power devices, the Pi uses an [ARM][2] CPU. This is a fun fact because that architecture was created by Acorn, the very same company that built the original BBC Micro! (the &#8220;Model A&#8221; and &#8220;Model B&#8221; boards are a clear pun on the [BBC Micro models][3].)

<div id="attachment_7406" class="wp-caption aligncenter" style="width: 610px">
  <a href="//chester.me/wp-content/uploads/2013/03/raspberry_pi.jpg"><img class="size-full wp-image-7406" alt="Here is my Pi, close to an SD card (to get an idea of its size). Yes, it's a full-fledged computer." src="//chester.me/wp-content/uploads/2013/03/raspberry_pi.jpg" width="600" height="450" /></a><p class="wp-caption-text">
    Here is my Pi, close to an SD card (to give an idea of its size). Yes, it&#8217;s a full-fledged computer.
  </p>
</div>

Like those old computers, you&#8217;ll use any TV or monitor (with its HDMI or composite input), and can play around without fear of breaking them, thanks to the absence of moving parts and the low price. But unlike them, you use SD Cards for storage. They are the dream of the 80&#8242;s hobbyist: fast and interchangeable like cartridges, reusable and manageable like floppy disks, and as cheap as cassette tapes (you can find a a 16GB Class 10 for less than $15).

Here is a cost breakdown (in CAD): I spent less than $50 on my board ([here][4]), and $10 on the case from the photo (although you can get [creative][5] and spend more/less). I used HDMI cables and a microUSB charger I had here (minimum is 700mA; I&#8217;d suggest at least 1A), but had no keyboard/mouse lying around, so I got [this mini keyboard with trackball][6] (which works fine, but is so short-ranged that defeats the purpose of being wireless).

A cheap Wi-Fi dongle got me wireless for another $15. It all depends on what you already have on your house, but you won&#8217;t spend more than you would on, say, an Apple TV &#8211; which provides a bit more of convenience, but a fraction of the functionality and pretty much none of the DIY fun.

<div id="attachment_7409" class="wp-caption aligncenter" style="width: 610px">
  <a href="//chester.me/wp-content/uploads/2013/03/first_boot.jpg"><img class="size-full wp-image-7409" alt="Terrible photo, but a milestone: first boot!" src="//chester.me/wp-content/uploads/2013/03/first_boot.jpg" width="600" height="450" /></a><p class="wp-caption-text">
    Terrible photo, but a milestone: first boot!
  </p>
</div>

The recommended software to start with is [Raspbian][7], a desktop-like Linux distribution to which you can add anything you want. But several custom-build distros were created for specific applications, like [OpenELEC][8] (a powerful XBMC-based media player) and [Sugar][9] (containing the educational software that runs on the One-Laptop-Per-Child machines).

But the nerdgasms came with [ChameleonPI][10] &#8211; a collection of emulators for dozens of old-school platforms. Apple II, MSX, ZX81, Spectrum, C64, Arcades (MAME), GameBoy, NES&#8230; you name it, ChameleonPI has it. Just throw your ROMs/DSKs/TAPs (or a willingness to write BASIC code) and have fun!

<p style="text-align: center;"><iframe width="640" height="360" src="https://www.youtube-nocookie.com/embed/Mvun7mTJX3A" frameborder="0" allowfullscreen></iframe></p>

Swapping cards is easy, but can be cumbersome and waste space, which makes [BerryBoot][11] useful: it hosts multiple distros on the same SD Card, showing a (customizable) menu for you to pick them. It also downloads most of the popular ones, straight from the Pi, with a couple of clicks. Linux geeks: it&#8217;s like apt, but for distros!

Unfortunatelly BerryBoot does **not** support ChameleonPI. You can add it manually (following the [instructions][12]), but BerryBoot expects a two-partition distro (and only uses the second, as the first one is the always the Raspbian boot partition). ChameleonPI v3 added a third one, allowing non-Linux users to copy ROMs to the SD card.

Since I&#8217;d rather use Wi-Fi to copy anyway, I tried to go without it. However, some of the emulators (notoriously [LinApple][13]) missed the directory structure &#8211; and I also could not write to /roms (the mount point for the partition). Here is what I did:

### <a name="chameleon_bb"></a>Steps to add ChameleonPI v0.3 to a BerryBoot SD

*   Download ChameleonPI and follow the [instructions][12] to add a custom system (ignoring that you&#8217;ll see three lines instead of two on the first step; keep using the second one);

*   Extract ChameleonPI to a separate SD and create a .tar.gz file with the contents of the FAT partition &#8211; it&#8217;s the one with AUTOEXEC.* files on the root and a lot of directories with old computer names;
    (**alternative**: download [my copy of the ChameleonPI v3 FAT partition][14])

*   Save that file to a pen drive/USB stick/external HD;

*   Plug the pen drive on the Raspberry Pi;

*   Boot the SD card with BerryMenu and select ChameleonPI.

*   Press T to open a terminal;

*   Ensure you can write to the /roms directory:

    <div class="code">
            <pre class="bash" style="font-family:monospace;"><span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">chown</span> zx <span style="color: #000000; font-weight: bold;">/</span>roms</pre>
    </div>

*   Also make sure the mount point for the pen drive is there:
    (thanks [@\_47Ronin\_][15] for pointing that out):

    <div class="code">
            <pre class="bash" style="font-family:monospace;"><span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">mkdir</span> <span style="color: #660033;">-p</span> <span style="color: #000000; font-weight: bold;">/</span>roms<span style="color: #000000; font-weight: bold;">/</span>USB</pre>
    </div>

*   Type `exit` to return to the ChameleonPI menu, then T again, and check if it mounted the pen drive (otherwise reboot and T again until the command shows some files):

    <div class="code">
            <pre class="bash" style="font-family:monospace;"><span style="color: #c20cb9; font-weight: bold;">ls</span> <span style="color: #000000; font-weight: bold;">/</span>roms<span style="color: #000000; font-weight: bold;">/</span>USB</pre>
    </div>

*   Extract the .tar.gz file there:

    <div class="code">
            <pre class="bash" style="font-family:monospace;"><span style="color: #7a0874; font-weight: bold;">cd</span> <span style="color: #000000; font-weight: bold;">/</span>roms
<span style="color: #c20cb9; font-weight: bold;">tar</span> <span style="color: #660033;">-xvzf</span> <span style="color: #000000; font-weight: bold;">/</span>roms<span style="color: #000000; font-weight: bold;">/</span>USB<span style="color: #000000; font-weight: bold;">/</span>chameleon.v03.fat.partition.tar.gz</pre>
    </div>

*   Reboot again

If everything works, LinApple will allow you to select a disk image pressing F3 (instead of crashing for not having the directory where it expects). You will now also be able to connect via Windows Network to your Pi (use the user *zx* and password *spectrum*) and mount the *roms* folder, not the *zx* one.

Also be aware that these instructions were tested with ChameleonPI 0.3, not with 0.3.1 (which is giving me a hard time to mount anywhere outside the Pi).

<div id="attachment_7408" class="wp-caption aligncenter" style="width: 610px">
  <a href="//chester.me/wp-content/uploads/2013/03/playing_with_turtle_graphics.jpg"><img class="size-full wp-image-7408" alt="Yes, I brought the Pi to Uken - why not doing turtle graphics alongside Rails?" src="//chester.me/wp-content/uploads/2013/03/playing_with_turtle_graphics.jpg" width="600" height="450" /></a><p class="wp-caption-text">
    Yes, I brought the Pi to Uken &#8211; why not doing turtle graphics alongside Rails?
  </p>
</div>

### Tips and Tricks:

*   You can do the image conversion (the &#8220;instructions&#8221; of the first step) on the Pi itself &#8211; it is way slower than any Linux desktop, but will work if you leave it working during the night as I did &#8211; just apt-get the software mentioned

*   XBMC becomes way more useful when you add [Fusion][16] (so other plugins can be added via the network)

*   All distros recognized my Wi-Fi dongle on-spot, but configuring the network can be tricky. OpenELEC adds an option with its own name on XBMC, under &#8220;System&#8221;, but some distros will require you to add your network to *wpa_supplicant.conf* (BerryBoot has it straight on the setup menu, others will look for it in */etc/wpa_supplicant/*).

    In any case, adding a block like this to the existing file should be enough:

    <div class="code">
            <pre class="bash" style="font-family:monospace;"><span style="color: #007800;">network</span>=<span style="color: #7a0874; font-weight: bold;">&#123;</span>
  <span style="color: #007800;">ssid</span>=<span style="color: #ff0000;">"your_wifi_network_name"</span>
  <span style="color: #007800;">psk</span>=<span style="color: #ff0000;">"your_wifi_password"</span>
<span style="color: #7a0874; font-weight: bold;">&#125;</span></pre>
    </div>

*   Make sure you set up the Wi-Fi (or have Ethernet plugged) because the Pi lacks a battery-backed clock, and needs to be online to show and use the correct date/time.

&nbsp;

 [1]: #chameleon_bb
 [2]: http://en.wikipedia.org/wiki/ARM_architecture
 [3]: http://en.wikipedia.org/wiki/BBC_Micro#Hardware_features:_Models_A_and_B
 [4]: http://www.creatroninc.com/
 [5]: http://www.bitrebels.com/technology/a-geeky-collection-of-creative-raspberry-pi-cases-15-pics/
 [6]: http://www.amazon.ca/IOGEAR-GKM681R-Wireless-Keyboard-Trackball/dp/B004OBAJCA
 [7]: http://www.raspbian.org/
 [8]: http://www.openelec.tv/
 [9]: http://wiki.laptop.org/go/Sugar
 [10]: http://chameleon.enging.com/
 [11]: http://www.berryterminal.com/doku.php/berryboot
 [12]: http://www.berryterminal.com/doku.php/berryboot#adding_your_own_custom_operating_systems_to_the_menu
 [13]: http://linapple.sourceforge.net/
 [14]: https://dl.dropbox.com/u/1545151/chameleon.v03.fat.partition.tar.gz
 [15]: https://twitter.com/_47Ronin_
 [16]: http://www.xbmchub.com/blog/2012/04/24/fusion-easy-addon-installation-for-xbmc/
