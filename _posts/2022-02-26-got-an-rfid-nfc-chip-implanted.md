---
layout: post
title: 'Got an NFC/RFID chip implanted in my hand'
og_image: /img/img/2022/02/measuring_large.jpg
description: "Becoming a cyborg in small steps"
comments: true
---

### RFID + NFC = NExT implant

The two cool technologies that I wanted to play with are [NFC](https://en.wikipedia.org/wiki/Near-field_communication) (which is used in mobile phones for contactless payments and contact exchanges) and [RFID](https://en.wikipedia.org/wiki/Radio-frequency_identification) (which is used in tags that identify/track objects, building access cards and other things)

_(I know, I know: technically, NFC is a set of protocols built upon a subset of the RFID ones, but I'm going with the commonplace usage of the terms: "RFID" for the unregulated "low frequency" 120-150 kHz tags that use all sorts of proprietary protocols, "NFC" for the "high frequency" 13.56 Mhz devices using specifically NFC)_

I didn't want to limit myself to a single technology (or to go with two implants), but Dangerous Things (yes, that's the company name) sells the [NExT](https://dangerousthings.com/product/next/): an implant with both an [RFID chip](https://github.com/RfidResearchGroup/proxmark3/blob/master/doc/T5577_Guide.md#t5577-overview) (that can simulate - or "clone" - fobs and tags on the wild) and an [NFC chip](https://www.nxp.com/products/rfid-nfc/nfc-hf/ntag-for-tags-labels/ntag-213-215-216-nfc-forum-type-2-tag-compliant-ic-with-144-504-888-bytes-user-memory:NTAG213_215_216) (which can store 888 bytes of data, accessible to any NFC reader I touch, including smartphones).

![The contraption used to inject it (after the fact) and some specs](/img/2022/02/needle_and_specs.jpg){: .center }

There are some limitations: its NFC can't be used for payments (like, for example, the [Walletmor](https://dangerousthings.com/product/walletmor/)), and the RFID can't emulate super advanced security, or hold multiple tags, but the combination is enough for a lot of uses, plus it's a field-tested set of chips that should be operational for years and years, so I chose it.

<!--more-->

### The implant process

Now that I knew what implant I wanted, the issue was how to get it implanted. Being quite afraid of something going wrong, I would prefer to get a physician to do it, but I didn't feel like bothering my family doctor with a non-elective procedure during a pandemic.

After some digging, I found the [Installation Partners](https://dangerousthings.com/partners/) section on the Dangerous Things website, which led me to [Midway Tattoo and Piercing](https://www.midwaytattoo.com/), a studio in Kensington, Toronto (where else?), where Matt Graziano kindly gave me a quote and scheduled a date.

I won't lie: I was quite afraid, but Matt - a biohacker himself who was quite excited with his (literally) shiny [xSIID NFC + LED implant](https://dangerousthings.com/product/xsiid/) - put me at ease. The entire procedure took a couple minutes, and honestly, was nearly painless (just a bit of blood). I even managed to film it with the other hand:

<p style="text-align: center;"><iframe width="465" height="840" src="https://www.youtube-nocookie.com/embed/TVAmycheQnA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></p>

### I'm a cyborg, here is my card

Well, the beauty of NExT is flexibility. Its high-frequency NTAG216 chip allows me to store several different classes of data (not unlike, say, a QR code) and have it accessed by any NFC-enabled phones when I touch them at the right spot, and it's the easiest thing to do, so I tried it first.

There are several Android and iOS apps that allow writing NFC data to the chip; I already had [NFC Tools PRO](https://play.google.com/store/apps/details?id=com.wakdev.nfctools.pro&hl=pt&gl=US), so I used it to store a [Linktree](https://linktr.ee/) address, turning my hand into a virtual business card:

<blockquote class="tiktok-embed" cite="https://www.tiktok.com/@chesterbr/video/7046586326728101126" data-video-id="7046586326728101126" style="max-width: 605px;min-width: 325px;" > <section> <a target="_blank" title="@chesterbr" href="https://www.tiktok.com/@chesterbr">@chesterbr</a> I am now a <a title="cyborg" target="_blank" href="https://www.tiktok.com/tag/cyborg">#cyborg</a> 😁 <a title="bodymodification" target="_blank" href="https://www.tiktok.com/tag/bodymodification">#bodymodification</a>  <a title="nfc" target="_blank" href="https://www.tiktok.com/tag/nfc">#nfc</a> <a title="chipimplant" target="_blank" href="https://www.tiktok.com/tag/chipimplant">#chipimplant</a> <a title="electronics" target="_blank" href="https://www.tiktok.com/tag/electronics">#electronics</a> <a target="_blank" title="♬ original sound - Chester" href="https://www.tiktok.com/music/original-sound-7046586258067344133">♬ original sound - Chester</a> </section> </blockquote> <script async src="https://www.tiktok.com/embed.js"></script>

### Hacking actual buildings

That is fun (although NFC support in phones on the wild is hit-and-miss, at least here in Canada). Anyway, The low-frequency T5577 RFID chip allows some other types of interesting applications, and the one I **really** wanted was to get rid of my building's access fob.

My kit came with the [Proxmark 3 Easy](https://www.proxmark.com/proxmark-3-hardware/proxmark-3-easy). The board is a somwewhat outdated member of the [Proxmark platform of open-source RFID hacking tools](https://en.wikipedia.org/wiki/Proxmark3), but very useful nonetheless for reading, writing and cracking several typesof RFID tags.

![Proxmark3 Easy](/img/2022/02/proxmark3.jpg){: .center }

Using it requires a client on your computer and a matching firmware on the board. There are several builds of those around, and my board came with ["Iceman"](https://github.com/RfidResearchGroup/proxmark3), one of the most feature-complete, but in a really old version, so I first had to update it, which requires building the client and firmware. Here is how I did it:

```bash
git clone https://github.com/RfidResearchGroup/proxmark3
cd proxmark3
cp Makefile.platform.sample Makefile
# at this point, edit Makefile.platform, uncommenting PLATFORM=PM3GENERIC (by removing the trailing #) and commenting any other PLATFORM=... line
make clean && make all
```

Any errors here are fixable by searching the web (for example, I had to do a [small fix to my Homebrew-installed openssl](https://stackoverflow.com/a/45196185/64635)). Once you build it, you can update the board's bootloader (recommended) with `./pm3-flash-bootrom`. It requires putting the board into bootloader mode by pressing its single button while plugging to the computer (my version was so old that I had to keep it pressed through the process).

![Me and Matt. Who said chips are the mark of the beast? His shop is decorated in the opposite direction... I think!](/img/2022/02/matt.jpg){: .right }

Once your bootloader is on a decent version, you use the same process (plug the board while pressing the button, but now you can release it) to update the firmware, just now running `./pm3-flash-fullimage`. Once _that_ is done, you can invoke `./pm3` to call the client - it will connect to the board, and the fun begins!

[These videos](https://dangerousthings.com/product/proxmark3-easy/) go a long way showing how to navigate the client menus; the most useful commands I learned are `lf search` and `hf search`, that try to read things on the LF (RFID) and HF (NFC) antennas, respectively. If they identify a tag, they will suggest further commands.

**In my case**, the command identified the tag as a [Kantech ioProx](https://kantech.com/Products/rkc_ioprox.aspx), which also uses a chip from the T55xx family and had no particular advanced protection. Yours is likely to be different, so do an [image search](https://duckduckgo.com/?t=ffab&q=ioprox+fob&atb=v199-1&iax=images&ia=images) to confirm you identified it correctly.

These tags are identified with a number in the format `XSF(XX)YY:CN`, where `XX` is the "version", `YY` is the "facility" and `CN` is the "card number". These are important because they are the parameters for the command that will reprogram the implant (or some other T55xx card/tag) to behave just like the tag, effectively "cloning" it.

With the right numbers in hand, you can use `lf io clone --vn xx --fn yy --cn CN` (`xx` and `yy` are the `XX` and `YY` from above, **converted to decimal**) to write the tag to the implant. Of course, other manufacturers/models of tags will require different commands (this is for the iOProx, hence the `io`), but the overall process is the same.

![Measuring it and getting ready](/img/2022/02/measuring.jpg){: .left }

Just be careful and notice the version and facility numbers are hexadecimal and need to be converted to decimal before using them. I not only made that mistake, but also wrote my tag in too close proximity to the original fob, so both my hand and the fob got the wrong info and were being rejected by the building on the first attempt 🤦‍♂️.

Fortunately I keep a long scrollback on my terminal, so I was able to figure out the difference and fix the mess. Lesson learned: **save the info returned** by `lf search` (`[+] IO Prox - XSF(XX)YY:ZZZZZ, Raw: NNNNNNNNNNNNNNNN (ok)`); the last number is a hash of the others, so you can use it to verify the tag.

Anyway, once that was sorted out, I was able to access my building with nothing but my bare hands:

<blockquote class="tiktok-embed" cite="https://www.tiktok.com/@chesterbr/video/7069206986822356229" data-video-id="7069206986822356229" style="max-width: 605px;min-width: 325px;" > <section> <a target="_blank" title="@chesterbr" href="https://www.tiktok.com/@chesterbr">@chesterbr</a> Used a Proxmark 3 Easy to copy the building fob to the NExT chip in my hand <a title="biohacking" target="_blank" href="https://www.tiktok.com/tag/biohacking">#biohacking</a> <a title="rfid" target="_blank" href="https://www.tiktok.com/tag/rfid">#RFID</a> <a title="nfc" target="_blank" href="https://www.tiktok.com/tag/nfc">#NFC</a> <a title="dangerousthings" target="_blank" href="https://www.tiktok.com/tag/dangerousthings">#dangerousthings</a> <a target="_blank" title="♬ original sound - Chester" href="https://www.tiktok.com/music/original-sound-7069206970661948166">♬ original sound - Chester</a> </section> </blockquote> <script async src="https://www.tiktok.com/embed.js"></script>

### Other applications

I feel like I just scratched the surface on what can be done with this dual chip implant. My bundle included a couple fobs and these cool hacking tools:

- [xEM Access Controller](https://dangerousthings.com/product/xac-v2/) is a board that memorizes fobs (including the implant) and can trigger your own hardware to build an an access management system or anything else
- [KBR1](https://dangerousthings.com/product/kbr1/) is a module that "types" any RFID tag's id on a computer, Raspberry Pi or anything that recognizes a USB keyboard
- [RFID diagnostic card](https://dangerousthings.com/product/rdc/) can identify tag readers as low frequency (LF) or high frequency (HF), so you know which chip to use.

I am tempted to use it somehow to open my apartment's door, but I am not sure whether the security that can be had with these technologies is good enough (the building fobs are ridiculously easy to copy, that I can attest). On the other *hand* 🥁, it's not like a regular key can't be easily copied too, so I'll ponder that possibility.

### Should I do it?

The idea of upgrading one's body with cybernetic parts is mesmerizing, I must admit. Surely, I'm not lifting cars like [The Six Million Dollar Man](https://www.imdb.com/title/tt0071054/), but mine didn't cost nowhere near that mark (which, to be fair, [would be more like 34 Million these days](https://www.in2013dollars.com/us/inflation/1974?amount=6000000)), and I'm having my share of fun with it.

RFID readers and fob cards/stickers/[rings](https://dangerousthings.com/product/magic-ring/) can be bought online, and are cheaper and less risky than and implant - but those can always be lost. Implant or no implant, there is a lot of fun to be had with NFC/RFID things.
