---
title: A step-by-step guide to configure encrypted Time Machine backups over a non-(Time Capsule) network share
layout: post
comments: true
permalink: /archives/2013/04/a-step-by-step-guide-to-configure-encrypted-time-machine-backups-over-a-non-time-capsule-network-share.html/
robotsmeta:
  - index,follow
dsq_thread_id:
  - 1753728447
categories:
---
[Time Machine][1] is a wonderful piece of software, in no small part for following Mac OS X&#8217;s philosophy of simplifying common tasks, but allowing advanced users to go &#8220;under the hood&#8221;. My issue: I wanted to back up to a hard disk shared by [this nice router][2], and I also wanted encryption.

<div id="attachment_7506" class="wp-caption aligncenter" style="width: 610px">
  <a href="http://www.imdb.com/title/tt0088763/"><img src="/wp-content/uploads/2013/04/time_machine.jpg" alt="The best Time Machines are designed in California." width="600" height="338" class="size-full wp-image-7506" /></a><p class="wp-caption-text">
    The best Time Machines are designed in California.
  </p>
</div>

Unfortunately, Time Machine won&#8217;t do network backups except on [Apple Time Capsule][3], most likely due to its [reliance on Unix hard links][4], which typical [Windows (SMB/CIFS)][5]/[FAT device][6] based networks (like mine) won&#8217;t do. [Filesystem-based encryption][7] is also a no-no. And even if that worked, my other devices (such as my [XBMC-powered Raspberry Pi][8]) need open access to the files already shared.

Mac OS X [sparse images][9] (aka sparse bundles) to the rescue. They are just like the `.dmg` files you get when downloading Mac software from a website, but supporting all the goodies mentioned above (encryption and hard links) and a bonus: they auto-grow (to a specified limit) as they need more space. Time Machine is capable to use one of those &#8211; as long as you can trick it into that, which can be tricky.

I found some great articles online on how to [create an sparse image][10], [encrypt it][11] and [convince Time Machine to use it][12], and here is a step-by-step mix of their tips that worked for me:

### Step 1: Naming the image

The image file name should contain your computer name and wi-fi address. To ensure that, open your [Terminal][13] and paste these commands:

<div class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #007800;">MAC_ADDRESS</span>=<span style="color: #000000; font-weight: bold;">`</span><span style="color: #c20cb9; font-weight: bold;">ifconfig</span> en0 <span style="color: #000000; font-weight: bold;">|</span> <span style="color: #c20cb9; font-weight: bold;">grep</span> ether <span style="color: #000000; font-weight: bold;">|</span> <span style="color: #c20cb9; font-weight: bold;">awk</span> <span style="color: #ff0000;">'{print $2}'</span> <span style="color: #000000; font-weight: bold;">|</span> <span style="color: #c20cb9; font-weight: bold;">sed</span> <span style="color: #ff0000;">'s/://g'</span><span style="color: #000000; font-weight: bold;">`</span>
<span style="color: #007800;">SHARE_NAME</span>=<span style="color: #000000; font-weight: bold;">`</span>scutil <span style="color: #660033;">--get</span> ComputerName<span style="color: #000000; font-weight: bold;">`</span>
<span style="color: #007800;">IMG_NAME</span>=<span style="color: #800000;">${SHARE_NAME}</span>_<span style="color: #800000;">${MAC_ADDRESS}</span>.sparsebundle
<span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #007800;">$IMG_NAME</span></pre>
</div>

If you read something like *&lt;name>_&lt;hexdigits>.sparsebundle*, you are good to go.

### Step 2: Creating the image and encrpyting it

Before you paste/type the next block of Terminal voodoo, change the line `MAXSIZE=750g` to the maximum size you want the sparse image to grow (after that, Time Machine will delete older backups, as usual), .e.g: `MAXSIZE=300g`. Use the same Terminal window from step 1, as this code depends on the name generated there.

<div class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #007800;">MAXSIZE</span>=750g
hdiutil create <span style="color: #660033;">-size</span> <span style="color: #007800;">$MAXSIZE</span> <span style="color: #660033;">-type</span> SPARSEBUNDLE <span style="color: #660033;">-nospotlight</span> <span style="color: #660033;">-volname</span> <span style="color: #ff0000;">"Backup of <span style="color: #007800;">$SHARE_NAME</span>"</span> <span style="color: #660033;">-fs</span> <span style="color: #ff0000;">"Case-sensitive Journaled HFS+"</span> <span style="color: #660033;">-verbose</span> unencrypted_<span style="color: #007800;">$IMG_NAME</span>
hdiutil convert <span style="color: #660033;">-format</span> UDSB <span style="color: #660033;">-o</span> <span style="color: #ff0000;">"<span style="color: #007800;">$IMG_NAME</span>"</span> <span style="color: #660033;">-encryption</span> AES-<span style="color: #000000;">128</span> <span style="color: #ff0000;">"unencrypted_<span style="color: #007800;">$IMG_NAME</span>"</span>
<span style="color: #c20cb9; font-weight: bold;">rm</span> <span style="color: #660033;">-Rf</span> <span style="color: #ff0000;">"unencrypted_<span style="color: #007800;">$IMG_NAME</span>"</span></pre>
</div>

You will be asked for a password (I&#8217;d [recommend a passphrase][14], but it&#8217;s up to you), and the sparse image file will be on your home folder.

**Do not** double click/open it yet.

### Step 3: Asking Time Machine to play nice

Open Finder and **move** the image from your home directory to the network share (or copy and **delete** the original). Now double-click to mount it, enter the password and the &#8220;Backup of *YourComputerName*&#8221; should appear on finder. [Hooray][15] &#8211; except that Time Machine won&#8217;t allow you to select it.

We&#8217;ll need to force its hand with this last block of commands (yet on that **same** Terminal window):

<div class="code">
        <pre class="bash" style="font-family:monospace;">defaults <span style="color: #c20cb9; font-weight: bold;">write</span> com.apple.systempreferences TMShowUnsupportedNetworkVolumes <span style="color: #000000;">1</span>
<span style="color: #c20cb9; font-weight: bold;">sudo</span> tmutil setdestination <span style="color: #ff0000;">"/Volumes/Backup of <span style="color: #007800;">$SHARE_NAME</span>"</span></pre>
</div>

Enter your Mac user&#8217;s password when prompted, and when you open Time Machine preferences, you&#8217;ll see &#8220;Backup of *your\_computer\_name*&#8221; configured as the backup volume. As long as it is mounted, it should work with Time Machine just like an USB HD.

### Caveat

As with standard Time Machine backups, these can be accessed by any Mac, as long as you have the volume password. I&#8217;m not sure, however, whether they can be used for a full restore on a new machine (probably yes if you do the first and third steps, but did not test that far).

Personally, I&#8217;m not much of a fan of doing full restore on a different machine/OS version. Although I&#8217;ve seen it work, I&#8217;d rather start from scratch, copying files from the latest backup of the old computer on a need-to basis. If you think otherwise, this solution may not be the best for you.

**UPDATE:** This was tested in Mac OS X versions 10.7.5 and 10.8.3. Older versions might work as long as they support encrypted bundles, but I&#8217;m not really sure. Let me know on comments below if it does not work for you (and what happened).

 [1]: http://support.apple.com/kb/ht1427
 [2]: http://reviews.cnet.com/routers/netgear-wndr3700-rangemax-dual/4505-3319_7-33485574.html
 [3]: http://www.apple.com/ca/timecapsule/
 [4]: http://pondini.org/TM/Works.html
 [5]: http://en.wikipedia.org/wiki/Server_Message_Block
 [6]: http://pcsupport.about.com/od/termsf/g/fat.htm
 [7]: http://support.apple.com/kb/ht4790
 [8]: /archives/2013/03/raspberry-pi-with-berryboot-and-chameleonpi.html
 [9]: http://en.wikipedia.org/wiki/Sparse_image
 [10]: http://www.levelofindirection.com/journal/2009/10/10/using-a-networked-drive-for-time-machine-backups-on-a-mac.html
 [11]: http://www.cognizo.com/2012/04/encrypted-network-backups-with-os-x-time-machine/
 [12]: http://basilsalad.com/how-to/create-time-machine-backup-network-drive-lion/
 [13]: http://en.wikipedia.org/wiki/Terminal_%28OS_X%29
 [14]: http://xkcd.com/936/
 [15]: http://www.youtube.com/watch?v=xr26lKyP3Z8
