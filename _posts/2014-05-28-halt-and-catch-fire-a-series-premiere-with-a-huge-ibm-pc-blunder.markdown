---
layout: post
title: "Halt and Catch Fire: a series premiere with a huge IBM PC blunder"
date: 2014-05-28 01:31
comments: true
og_image: /img/2014/05/debug.png
categories:
---
Just watched AMC's [first episode of Halt and Catch Fire][1] - a TV show that about a hyper-stereotyped bunch (chrarming entrepreneur, family-man engineer and punk-girl hacker) facing "big corps" of the early 80s. And they start by challenging no one less than IBM, so I *had* to check it out.

Every fiction piece about computers has one innacuracy or another, and I usually just eat my popcorn and enjoy the show. But this one had an issue too close to home to be ignored. And it started with a good idea: they borrowed the plot from Phoenix Technologies' [cloning of the IBM PC BIOS][2], which I'd summarize like this:

In order to run software made for the IBM PC, a computer would need a piece of software knonw as the BIOS. It was inside every IBM computer, but was dutifully copyrighted. Copying or mimicking it directly would likely result in legal action, but Phoenix got over that (and sold their version to several IBM PC clone manufacturers) by having two teams on the job: one studied the code and wrote specifications on how it worked, and another created a new BIOS only from reading such specifications, making it a "clean room" reverse engineering.

The episode puts the hacker girl in the role of the second team, while the engineer guy replaces the first (helped by the entrepreneur). Also, his task was simplified into just generating a printout of the BIOS that the girl would recreate. Things were fine up to this point, but the male duo would accomplish the task in the most complicated way possible: they hooked the guts of the computer to a LED panel, which would show a binary representation of the codes, one digit at a time. Then they would write each one on a block of paper and *then* type it all (into the reassembled PC or another computer, not sure), and *finally* print it all out!

Heck, I understand the need for dramatizing the effort. And I also wasn't for sure the genius computer designer this engineer is supposed to be, but if you asked *me* how to do that in the IBM PC era, I would likely just suggest typing these two commands:

```bat
debug
d f000:0000
```

The first line calls [debug][3], the monitor/assembler/disassembler tool that came with DOS since verison 1.0. The second one (typed under debug's `-` prompt) will dump (`d`) the contents of the first 128 bytes of the PC-BIOS. It will even print the characters that match each code (revealing some of the messages printed when you turned the computer on), and typing `d` again will reveal the next batch of 128 bytes, again and again. Attach a printer and you are done.

But don't take my word for it: go to James Friend's nice [PC emulator][6] page (based on PCE) and try the commands yourself (the page actually emulates a slightly more modern computer, but it boots in the IBM-PC-like "[real mode][7]"). You will get a result like this:

![](/img/2014/05/debug.png){: .center }

Some people may argue they could not know the location (`F000:0000`) without Google, but the [IBM PC technical manual (PDF)][4] that came with it tells you on page 1-12 that it's located at `F0000` (an absolute 8086[^10] address that can be referred to as `F000:0000`). Even if IBM had hidden it, the [Intel 8086 manual (PDF)][5] reveals (in page 2-29, table 2-4) that the processor boots at the `FFFF:0000` address (CS:Instruction Pointer). Typing `u FFFF:0000` on debug would reveal the first instruction ran is a `JMP` to the beginning of the BIOS code (just after a few header bytes), and one would reasonably dump from it until the end of memory, which would match the ROM chip capacity (which was also public information).

But wait, there is more: if they had really bothered **reading** the aforementioned PC manual, they could have saved some ink and paper. Appendix A contains the fully disassembled BIOS code - meaning those guys spend a whole weekend printing something that was already on the box, in an easier to read format. Geniuses.

Having that out of my chest, I can focus on the episode itself: it was ok-ish. I may check future ones if they appear on the website/over-the-air/Netflix/whatever, but I'm not really holding my breath.

[1]: http://www.amctv.com/full-episodes/halt-and-catch-fire/3571290828001/i-o-full-episode
[2]: http://en.wikipedia.org/wiki/Phoenix_Technologies#Cloning_the_IBM_PC_BIOS
[3]: http://en.wikipedia.org/wiki/Debug_%28command%29
[4]: http://www.retroarchive.org/dos/docs/ibm5160techref.pdf
[5]: http://matthieu.benoit.free.fr/cross/data_sheets/8086_family_Users_Manual.pdf
[6]: http://jamesfriend.com.au/pce-js/ibmpc-games/
[7]: http://en.wikipedia.org/wiki/Real_mode
[^10]: As pointed by Clonejay, the IBM PC actually had an 8088 processor. Programmers (including myself) tend to refer to it as 8086 because [software-wise, they were identical](http://en.wikipedia.org/wiki/Intel_8088). The 8088 had a smaller data bus, compatible with cheaper-but-slower RAM chips). You won't find much 8088-specific documentation, so I'll keep the text as-is.
