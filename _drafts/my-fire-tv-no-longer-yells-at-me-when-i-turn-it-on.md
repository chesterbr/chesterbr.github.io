---
locale: en
layout: post
title: 'My Fire TV no longer yells at me when I turn it on'
description: "How I stopped the full-screen ad with sound on my Fire TV, trimmed the Amazon extras I never use, and turned it into a reusable Claude Code skill."
comments: true
categories:
  - software
---

I usually hate "smart" TVs, becuase most are dumb and bloated. But Fire TV caught I absolutely love my Fire TV: UI is fast,
Every time I turned on my Fire TV, a full-screen video ad started playing, with sound. (If it at least came in muted, I could live with it.) Lately the thing also felt slower, so I went looking.

<!--more-->

The ad turned out not to be an app I could remove. It plays inside the Home screen itself, as the "featured content" autoplay. Amazon has switches for that under Preferences; I flipped the underlying setting over ADB because I was already there. The carousel is still on the screen, but now it's silent and still. The Home screen app is protected, and replacing it is a different (and riskier) project.

While I was in there I also disabled ten Amazon packages I never use (shopping, the ad-filled screensaver, on-screen content tracking, miniTV, the games hub, Amazon Music and Photos), turned off interest-based ads and usage metrics, and trimmed the app caches, which gave back 1 GB of the 11 GB on the box. Waking from sleep got noticeably faster. I didn't benchmark anything, so take that as one person's impression. With 1.7 GB of RAM the real limit is memory, so I'd credit the packages, not the cache.

Here is how I did it:

**BEFORE APPLYING, PLEASE READ THIS.**

- Only on a device you own. Amazon documents ADB debugging for developers; that's all this uses. No root, no exploits, nothing sideloaded.
- Nothing here is permanent, but a wrong choice can still break a feature (Home, HDMI inputs, the remote). Fire OS updates may switch things back on.
- I tested on one model (code AFTTI43, Fire OS 7). Yours may differ.

On the TV: Settings > My Fire TV > About, click the device name seven times, then Developer options > ADB debugging on. Then, from a computer:

```
adb connect <tv-ip>:5555
adb shell pm disable-user --user 0 com.amazon.tv.acr       # repeat per package
adb shell settings put global com.amazon.tv.settings.featured_item_video_enabled 0
adb shell pm trim-caches 9G
# undo a package:
adb shell pm enable com.amazon.tv.acr
```

Switch ADB debugging off when you're done. Don't leave it on outside a trusted home network.

I turned all of this into a [Claude Code skill](https://github.com/chesterbr/dotfiles/blob/main/claude/skills/debloat-fire-tv/SKILL.md), so I can re-run it after an update and on my other TV. It connects, checks the model, shows a plan, applies only what's missing, and saves a restore script. It also keeps a list of what's safe to disable and what to leave alone. MIT licensed.

**Fine print.** I'm not affiliated with Amazon, and I'm not a lawyer. I found no term that prohibits this and no report of anyone being penalized for it, but that's not a guarantee, and terms change. If Amazon or anyone else thinks this crosses a line, write to me first and I'll promptly change or remove the part in question.

The carousel is still there, mute. I'm choosing to think of it as a screensaver.
