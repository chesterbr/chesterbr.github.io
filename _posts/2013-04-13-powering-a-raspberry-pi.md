---
title: Powering a Raspberry Pi
layout: post
comments: true
permalink: /archives/2013/04/powering-a-raspberry-pi.html/
robotsmeta:
  - index,follow
dsq_thread_id:
  - 1751448369
categories:
---
The [Raspberry Pi][1] is powered through an standard micro-USB conector. That is great, since it allows you to use pretty much any phone charger you got lying around. Or at least one that supplies 700mA of current (maybe a bit more if you plug extra USB stuff on the Pi).

I thought I had it covered with my [iPad charger][2] and its [juicy 2.1A][3], but the video below shows that voltage also plays a role (and that the iPad charger doesn&#8217;t really deliver in that respect):

<div style="text-align: center;">
  <iframe width="560" height="315" frameborder="0" allowfullscreen="" src="http://www.youtube.com/embed/XX3kiRUf7mg"></iframe>
</div>

[USB specs][4] say you should have 5V ± 0.25V from a source, and the Pi also expects that, so I bought a $9 KDL-5100A at my [electronics parts supplier][5]. It is physically identical to [the FY0501000 linked on the video][6], and indeed, performed better than the iPad charger&#8230; but still below 4.75.

After some head-scratching, I found the issue: the cable. Apparently, [cheap cables have quite some resistance][7], which causes voltage drops as you need more current ([Ohm&#8217;s Law][8], I suppose). Replaced it with [a Samsung one][9], and *voilà*: iPad charger got almost good, and new charger worked **great.**

An LG cable (with no Part number) got me pretty much the same results. Also tested the cable on an [Apple Cinema Display][10] USB port (okay) and a BlackBerry Playbook charger with built-in cable (excellent). Heard good things about the Kindle Fire charger, but could not test it yet.

<div id="attachment_7536" class="wp-caption aligncenter" style="width: 410px">
  <a href="http://en.wikipedia.org/wiki/Cable_%28comics%29"><img class="size-full wp-image-7536 " alt="Guess who was causing trouble?" src="//chester.me/wp-content/uploads/2013/04/cable.jpg" width="400" height="324" /></a><p class="wp-caption-text">
    Guess who was causing trouble?
  </p>
</div>

Below is a wrap-up of my measurements (Wi-Fi and keyboard dongles plugged); recommended options in **bold**. In short: get a proper charger, avoid $1 cables and always [measure][11].

<div>
  <table style="margin: auto; border: 1px solid black;">
    <tr>
      <th style="text-align: center;">
        Charger
      </th>

      <th style="text-align: center;">
        Cable
      </th>

      <th style="text-align: center;">
        Power (V)
      </th>
    </tr>

    <tr>
      <td>
        Apple A1357
      </td>

      <td>
        Cheap unbranded
      </td>

      <td style="text-align: center;">
        4.16 &#8211; 4.56
      </td>
    </tr>

    <tr>
      <td>
        Apple A1357
      </td>

      <td>
        Samsung APCBU10BBECSTD
      </td>

      <td style="text-align: center;">
        ~4.75
      </td>
    </tr>

    <tr>
      <td>
        KDL-5100A
      </td>

      <td>
        Cheap unbranded
      </td>

      <td style="text-align: center;">
        4.65 &#8211; 4.75
      </td>
    </tr>

    <tr>
      <td>
        Cinema Display USB Port
      </td>

      <td>
        Samsung APCBU10BBECSTD
      </td>

      <td style="text-align: center;">
        4.75 &#8211; 4.81
      </td>
    </tr>

    <tr>
      <td>
        <strong>KDL-5100A</strong>
      </td>

      <td>
        <strong>Samsung APCBU10BBECSTD</strong>
      </td>

      <td style="text-align: center;">
        <strong>4.90 &#8211; 4.95</strong>
      </td>
    </tr>

    <tr>
      <td>
        <strong>BlackBerry HDW-34724-001</strong>
      </td>

      <td>
        <strong>built-in</strong>
      </td>

      <td style="text-align: center;">
        <strong>4.99 &#8211; 5.01</strong>
      </td>
    </tr>
  </table>
</div>

**CLARIFICATION**: The [video][12] above is not mine. It was just the inspiration for my own measurements, so I included it for illustration purposes.

 [1]: http://en.wikipedia.org/wiki/Raspberry_Pi
 [2]: http://www.amazon.com/Apple-iPad-Power-Adapter-MC359LL/dp/B004GIKW6Y/ref=sr_1_4?s=electronics&ie=UTF8&qid=1365826931&sr=1-4&keywords=a1357
 [3]: https://discussions.apple.com/docs/DOC-3511
 [4]: http://en.wikipedia.org/wiki/Universal_Serial_Bus#Power
 [5]: http://www.creatroninc.com/
 [6]: https://www.adafruit.com/products/501#Technical%20Details
 [7]: http://elinux.org/On_the_RPi_usb_power_cable
 [8]: http://en.wikipedia.org/wiki/Ohm%27s_law
 [9]: http://www.samsung.com/in/consumer/mobile-phone/mobile-phone/mobile-phone-accessories/APCBU10BBECSTD?subsubtype=data-cable
 [10]: http://store.apple.com/us/product/MC007LL/A/apple-led-cinema-display-27-flat-panel
 [11]: http://elinux.org/R-Pi_Troubleshooting#Troubleshooting_power_problems
 [12]: http://youtu.be/XX3kiRUf7mg
