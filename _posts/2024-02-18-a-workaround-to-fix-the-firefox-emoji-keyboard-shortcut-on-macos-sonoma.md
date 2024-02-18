---
layout: post
title: 'A workaround to fix the Firefox emoji keyboard shortcut on macOS Sonoma'
og_image: /img/2024/02/hammer-keyboard.jpeg
description: "A macOS update broke the Firefox emoji keyboard shortcut, and the official fix will take a while to be released. Here's a workaround to fix it now."
comments: true
---

macOS 14 (Sonoma) [broke](https://bugzilla.mozilla.org/show_bug.cgi?id=1855346) the "Emoji & Symbols" keyboard shortcuts (`fn/🌐`+`e` or `control`+`cmd`+`space`) on Firefox: instead of opening, the emoji picker briefly flashes and disappears:

![The "Emoji & Symbols" panel briefly flashes and disappears](/img/2024/02/emoji-flash.gif){: .center }

If you use the "Edit... Emoji & Symbols" menu, the picker works - but it's annoying to reach out for the mouse whenever you need an emoji or special character! I thought such an inconvenient bug would be fixed quickly on a minor Firefox or macOS update, but months passed and the bug was still there.

Between annoyed and curious, I dug the [source code](https://firefox-source-docs.mozilla.org/contributing/directory_structure.html) a bit and wrote a [patch](https://phabricator.services.mozilla.com/D193328) that fixes it, and also a [secondary problem](https://bugzilla.mozilla.org/show_bug.cgi?id=1833923) with the `fn/🌐`+`e` shortcut (introduced in Monterey as a replacement/alternative for `control`+`cmd`+`space`): it works sometimes, but when it does, it also writes the letter "e" where the cursor is, which is equally irksome.

For reasons that I will explain below, Mozilla did not accept the fix. They are working on another solution, but it will take a while to be released. Since [many people have the problem right now](https://web.archive.org/web/20240218153259/https://www.reddit.com/r/firefox/search/?q=emoji%20mac&restrict_sr=1&rdt=60658), I decided to share some details about my fix here, alongside with instructions for [applying the patch to the official Firefox source code](/archives/2024/02/a-workaround-to-fix-the-firefox-emoji-keyboard-shortcut-on-macos-sonoma/#applying-the-patch) or [downloading my patched version](/archives/2024/02/a-workaround-to-fix-the-firefox-emoji-keyboard-shortcut-on-macos-sonoma/#downloading-emojifox) - which I rebranded "EmojiFox" to avoid confusion and respect Mozilla's trademarks/license.

<!--more-->

### Finding and fixing the bug

(skip to the [next section](/archives/2024/02/a-workaround-to-fix-the-firefox-emoji-keyboard-shortcut-on-macos-sonoma/#what-are-my-options) if you are not interested in the programming details and just want a workaround for the bug)

One thing that caught my attention was that this bug [also happened with Chrome](https://issues.chromium.org/issues/40934002) after the macOS Sonoma update. They quickly produced a [fix](https://chromium.googlesource.com/chromium/src/+/cd62b1ad7d6557f6f6df26080d0305fb19622a1b%5E%21/) - a surprisingly short one:

```diff
     if (is_a_system_shortcut_event) {
       [[NSApp mainMenu] performKeyEquivalent:theEvent];
+
+      // Behavior changed in macOS Sonoma - now it's important we early-out
+      // rather than allow the code to reach
+      // _hostHelper->ForwardKeyboardEventWithCommands(). Go with the existing
+      // behavior for prior versions because we know it works for them.
+      if (base::mac::MacOSVersion() >= 14'00'00) {
+        _currentKeyDownCode.reset();
+        _host->EndKeyboardEvent();
+        return;
+      }

     } else {
       [self interpretKeyEvents:@[ theEvent ]];
     }
```

It gives some hints on the root cause: the app is forwarding the system shortcut event, instead of stopping it. It caused no harm before Sonoma, but after it, it results in the shortcut triggering **twice**, and the second trigger closes the picker. You can check it by pressing the shortcut twice in quick succession on any _other_ (non-buggy) app: it cause the exact behavior of the bug!

With that in mind, I downloaded the [Firefox source code](https://hg.mozilla.org/mozilla-central) and started poking at it. It's a quite large (but [well documented](https://firefox-source-docs.mozilla.org/)) codebase, but I didn't need to understand it all - just had to find a suitable place to stop the event processing. Finding one, I produced a [proof-of-concept](https://bugzilla.mozilla.org/show_bug.cgi?id=1855346#c16), which crudely detected the key combinations and abruptly stopped processing:

```objc
if (((anEvent.modifierFlags & NSEventModifierFlagControl) &&
     (anEvent.modifierFlags & NSEventModifierFlagCommand) &&
     anEvent.keyCode == 49) ||
    ((anEvent.modifierFlags & NSEventModifierFlagFunction) &&
     anEvent.keyCode == 14)) {
  return;
}
break;
```

That worked, but wouldn't be much useful because users can redefine the emoji keyboard shortcut, so the only way to figure out whether an event is the shortcut I want to prevent is to go through the menus and find one that matches the event keys _and_ triggers the action of opening the emoji picker. Chrome already had [code](https://source.chromium.org/chromium/chromium/src/+/main:ui/base/cocoa/nsmenuitem_additions.mm;l=128-279;drc=28154a6fbbcaa037ae8692d96bc114286c57f6c7) for that, so I had to add something equivalent to Firefox:

```objc
// Determines whether the key event matches the shortcut assigned to the Emoji &
// Symbols menu item, so we can avoid dispatching it (and closing the picker).
//
// It works by looking for a second-level menu item that triggers the picker AND
// matches the shortcut, skipping any top-level menus that don't contain picker
// triggers (avoiding potentially long menus such as Bookmarks).
//
// It handles fn-E (the standard shortcut), ^⌘Space (which appears in a hidden
// menu when the standard is not redefined) and custom shortcuts (created via
// System Settings > Keyboard > Keyboard Shortcuts > App Shortcuts), save for a
// few complex key combos that send incorrect modifiers.
static bool IsKeyEventEmojiAndSymbols(NSEvent* event, NSMenu* menu) {
  SEL targetAction = @selector(orderFrontCharacterPalette:);
  for (NSMenuItem* topLevelItem in menu.itemArray) {
    if (topLevelItem.hasSubmenu &&
        [topLevelItem.submenu indexOfItemWithTarget:nil
                                          andAction:targetAction] != -1) {
      for (NSMenuItem* item in topLevelItem.submenu.itemArray) {
        if (item.action == targetAction) {
          NSString* itemCharacters = [[item keyEquivalent] lowercaseString];
          NSUInteger itemModifiers = [item keyEquivalentModifierMask];
          NSString* eventCharacters =
              [[event charactersIgnoringModifiers] lowercaseString];
          NSUInteger eventModifiers =
              [event modifierFlags] &
              NSEventModifierFlagDeviceIndependentFlagsMask;

          if ([itemCharacters isEqualToString:eventCharacters] &&
              itemModifiers == eventModifiers) {
            return true;
          }
        }
      }
    }
  }
  return false;
}
```

(a nice bonus of doing that was discovering how Apple managed to replace `control`+`cmd`+`space` with `fn/🌐`+`e` on the menu, yet the old shortcut still worked: they keep **two** menu items for "Emoji & Symbols", but the one linked to the `control`+`cmd`+`space` shortcut is hidden)

With that in place, the fix is as simple as Chrome's:

```objc
// Early exit if Emoji & Symbols shortcut is pressed; fixes bug 1855346
// (first seen on macOS Sonoma) and bug 1833923 (first seen on Monterey)
if ((nsCocoaFeatures::OnMontereyOrLater()) &&
    IsKeyEventEmojiAndSymbols(aNativeEvent, [NSApp mainMenu])) {
  return currentKeyEvent->IsDefaultPrevented();
}
```

It turns out that doing this on the right place fixes not only the "flashing" bug, but the "e" one as well, because the later is also being processed twice, but `fn/🌐` being such a [special](https://github.com/qmk/qmk_firmware/issues/2179) key on the Mac, sometimes the second occurrence loses the `fn`, acting as the `e` key being pressed right after the `fn/🌐`+`e`. That's why I only apply the check to Monterey or later (after confirming that the "e" bug was introduced in Monterey, and the "flashing" one in Sonoma).

!["Person with a hammer hitting a keyboard"](/img/2024/02/hammer-keyboard.jpeg){: .right }

Of course it took me quite some time and learning to get there, and the true heroes are the Mozilla developers who kindly gave me feedback and pointed me towards the right direction at every step. At the end, we had a [patch](https://phabricator.services.mozilla.com/D193328) that fully fixed both problems, addressing all performance and compatibility concerns with the traversal.

However, those same Mozilla developers reasoned it would be better to prevent the event from trickling down at all instead of catching it on the `TextInputHandler` (and catch _any_ system shortcut events, not just the emoji picker one, which would avoid the need to traverse menus altogether), and wrote a [different](https://phabricator.services.mozilla.com/D195016) patch in that direction.

I was happy with that: I learned a lot, helped raising awareness and researching towards the cleanest solution, and - most important - the bug would soon be fixed for good. But a couple months passed, Firefox got a few major version updates, yet the keyboard shortcut was still broken!

So I [asked](https://bugzilla.mozilla.org/show_bug.cgi?id=1855346#c43) around, and it seems the  cleaner patch fixes the "flashing" issue, but **not** the "e" bug. They are actively working on a second patch for that, and will release both together - which is technically the best approach, but will take a while to be available for Firefox + Mac users.

### What are my options?

If you are affected by this bug, you can:

1. **Wait for the official fix**. This is the simplest and safest option, but considering the [release calendar](https://whattrainisitnow.com/calendar/), my best guess is that a fix won't come before Firefox 125 (due April 16).

2. **Apply my patch to the Firefox source code and build it**. This is also very safe: you don't need to trust anyone but Mozilla, since you are using their code (which you already trust as a Firefox user) and my patch (which is public and you can review). But it requires familiarity with the command line and _a lot_ of time to compile the browser.

3. **Download and install EmojiFox**, that is, Firefox Nightly/Unofficial with my patch applied. The downsides: you have to trust me and it won't auto-update - you should throw it away as soon as the official fix is released.

### Applying the patch

First step is to download and build Firefox on macOS by following the [official instructions](https://firefox-source-docs.mozilla.org/setup/macos_build.html). Just keep in mind that:

- You should *not* select [artifact builds](https://firefox-source-docs.mozilla.org/contributing/build/artifact_builds.html) when asked, as they are based on pre-built binaries and you need to build the binaries yourself.
- Before running `./mach build`, you should add `ac_add_options --enable-release` to your `.mozconfig` file (and comment out any debug-related options, or pretty much anything but this one)

`./mach build` takes a few hours, even on a beefy machine. Once you are running Nightly, confirm the bug is still there, then apply the patch with:

```sh
curl -L https://phabricator.services.mozilla.com/D193328?download=true | patch
```

and `./mach build` again (don't worry, it will be much faster, since it only recompiles the files that changed), then `./mach run` again. You should see the bug fixed now:

!["Emoji & Symbols" shortuct now opens the full or contextual panel](/img/2024/02/fix.gif){: .center }

You are not done yet - even though there is a `Nightly.app` that you can copy, it will be bound to assets that will disappear once you clean up your building environment. So now run:

```sh
./mach package
```

That will generate a `.dmg` file in your `obj-x86_64-apple-darwin23.1.0/dist` folder (or `obj-arm64/dist` if you are using an Apple Silicon Mac). That `.dmg` contains a `Nightly.app` that you can copy to your Applications folder and use as your main browser.

### Downloading EmojiFox

I have been using Firefox 121 with this path since December, and recently re-applied it to the nightly build of Firefox 124. You can download this patched version (which I rebranded as "EmojiFox") as long as you keep in mind that:

- I (Chester) do not represent Mozilla, and this is **not** a Mozilla/Firefox official release.
- This software will **not** auto-update, and I don't intend to release new versions (by the time it gets old, we should have the proper fix on official Firefox). It's a workaround that you should throw away and go back to default Firefox as soon as a fixed version is released. Always keep your browser updated!
- Neither I, nor Mozilla, nor anyone is responsible for any damage caused by the patched version.
- Per [Mozilla Public License](https://www.mozilla.org/en-US/MPL/) terms, my source code changes are available [here](https://phabricator.services.mozilla.com/D193328) ([raw diff](https://phabricator.services.mozilla.com/D193328?download=true)).

<style>
  #emojifox-download-div {
    display: none;
  }

  #emojifox-agree-with-terms-checkbox:checked + label + #emojifox-download-div {
    display: block;
    border: 2px solid;
    padding-top: 16px;
    padding-right: 16px;
    width: fit-content;
    margin: 10px auto 10px auto;
  }
</style>
<form style="padding-bottom:12px">
  <input type=checkbox id="emojifox-agree-with-terms-checkbox" />
  <label for="emojifox-agree-with-terms-checkbox"><strong>I <u>read</u> and <u>agree</u> with the terms above</strong> (click to show download links)</label>
  <div id="emojifox-download-div">
    <ul>
      <li><a href="/download/EmojiFox-124.0a1.en-US.mac.x86_64.dmg">Download EmojiFox 124.0a1 for Intel Macs</a></li>
      <li><a href="/download/EmojiFox-124.0a1.en-US.mac.arm64.dmg">Download EmojiFox 124.0a1 for Apple Silicon Macs</a></li>
    </ul>
  </div>
</form>

Open the file and drag EmojiFox to your Applications folder, as usual. But when you run the app, it will say it's from an unidentified developer (I currently don't do enough macOS development to justify the yearly USD 99 for an Apple Developer Program membership that would allow me to sign it).

![Dialog saying EmojiFox cannot be opened because the developer cannot be verified, with no option to override](/img/2024/02/cannot-be-opened.png){: .center }

The [trick](https://support.apple.com/en-ca/guide/mac-help/mh40616/mac) here is to hold `control` while clicking the app icon, then select "Open" from the context menu. It will also show a warning, but now there will be an `Open` button that will open the app. You only need to do this once - from now on, it will open normally.

![Aslo a dialog saying EmojiFox cannot be opened because the developer cannot be verified, with but now it has an Open button](/img/2024/02/cannot-verify.png){: .center }

Verify that both the `control`+`cmd`+`space` and `fn/🌐`+`e` shortcuts work as expected.

!["Emoji & Symbols" shortuct on EmojiFox](/img/2024/02/emojifox.gif){: .center }


### Use your existing profile

Regardless of whether you built or downloaded your fixed browser, you will want to bring your existing bookmarks, history, extensions, etc. to it, and the easy way to do that is to configure it to use your existing profile (instead of the one it just created).

To do so, ensure the original Firefox is closed, and type `about:profiles` at the new browser's address bar. Click `Set as default profile` on your Firefox profile, restart the browser and you should see your bookmarks, history, extensions, etc.

(if you have multiple profiles and don't know which is the right one, just try `Launch profile in new browser` on any candidates)

### Final considerations

The only issue I had with this build so far: unlocking the 1Password extension doesn't work with Touch ID (I suppose it's because it isn't an official release); you can still unlock with your password, and/or use Touch ID on the 1Password application. It's a minor trade-off for people who, like myself, type emoji _much_ more often than log on to websites.

If you try any of these solutions, please let me know in the comments below whether it worked for you or not. And let's 🤞 for Mozilla to release the official fix soon (they are working on it) so we don't need these workarounds anymore!
