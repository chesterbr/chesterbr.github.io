---
layout: post
title: "Running ruby2600 in a browser with Opal"
comments: true
og_image: /img/2014/02/ruby2600_fb_logo.png
categories:
---

![ruby2600](/img/2014/02/ruby2600.png){: .right }

Last year I challenged myself into writing an Atari 2600 emulator using Ruby in time to present it at [RubyConfBr][1] 2013 - thus [ruby2600][2] was born. When I found [Opal, a Ruby-to-JavaScript compiler][3], I felt it might be fun to run the emulator on a browser.

[1]: http://www.rubyconf.com.br
[2]: https://github.com/chesterbr/ruby2600
[3]: http://opalrb.org/
[4]: https://en.wikipedia.org/wiki/Ruby_MRI

It runs even slower than in [MRI][4] and is far from polished, but works. To watch it, just click the button below and **wait** until the black lines get replaced by Pitfall Harry slooooowly running to the left (sorry, no key bindings for now).

Keep reading if you want the gory technical details!

<button onClick="i=document.getElementById('iframe_ruby2600'); i.height='220px'; i.src='/ruby2600/ruby2600.html'; i.scrollIntoView();">Click here to run ruby2600 in your browser</button>
<iframe id="iframe_ruby2600" width="100%" height="1px" scrolling="no"></iframe>

<!--more-->

## Being browser-friendly

Ruby2600 is fairly portable across Ruby interpreters ([JRuby][9], for example, doubles its speed) and graphic libraries. A typical port consists on a script that:

- Calls the `Bus#frame` method and renders the resulting array of pixels into an image (translating [Atari 2600 NTSC colors][11] into native ones); and
- Triggers actions accordingly (e.g., sets `Bus#p0_joystick_right` to `true` to move the Player 0's joystick to the right).

[HTML5 Canvas][10] is the ideal place to render those frames, not only for its ability of addressing individual bits, but also for allowing horizontal stretch, which compensates Atari 2600's rectangular pixels. So I wrote a [minimal HTML][13], some [rendering code][14] and...

![ruby2600](/img/2014/02/wait.png){: .center }

Generating a frame is CPU-intensive, and browsers don't like functions that run for too long. The [fix][8]: expose a `Bus#scanline` method and render scanline-by-scanline [chaining calls to `setTimeout(..., 0)`][12], giving the browser some breathing space.

[8]: https://github.com/chesterbr/ruby2600/blob/2e15eedad5b381a20741ab44bdd4a249d128c58c/bin/ruby2600-opal.rb#L158-L188
[9]: http://jruby.org/
[10]: http://www.w3schools.com/html/html5_canvas.asp
[11]: https://en.wikipedia.org/wiki/Television_Interface_Adapter#TIA_Color_Capabilities
[12]: http://stackoverflow.com/questions/779379/why-is-settimeoutfn-0-sometimes-useful
[13]: https://github.com/chesterbr/ruby2600/blob/2e15eedad5b381a20741ab44bdd4a249d128c58c/ruby2600.html
[14]: https://github.com/chesterbr/ruby2600/blob/763635123106e6b138f05ad7a88eafee4211cc26/bin/ruby2600-opal.rb#L160-L189

## Patching Opal

On my first run, the emulated game crashed straight after a few hundred CPU instructions. It would be a nightmare to debug, *if* ruby2600 did not have extensive automated tests (which I ended up [migrating to RSpec 3][15] to get rid of deprecated syntax that did not please [opal-rspec][16]).

The specs revealed Opal missed [bit indexing][28] and had issues with peculiar cases of [array expansion][29] and [binary shift][30]. Those operations are seldom found in typical Ruby code, but are essential to ruby2600.

Open-source to the rescue: [a few patches][27] to Opal fixed these problems (one of the tests even [made its way into Rubyspec][26]), leaving me with one last problem: integer division.

Opal [translates all numeric classes][24] to JavaScript native numbers, which is great for performance and simplicity, but also makes it unable to tell `3 / 2` (=1) apart from `3.0 / 2` (=1.5). Had to wrap such divisions in `( ).to_i` - a bit of noise, but a small price for the awesomeness of cross-compilation.

[15]: http://myronmars.to/n/dev-blog/2013/11/rspec-2-99-and-3-0-betas-have-been-released
[16]: https://github.com/opal/opal-rspec#readme
[24]: http://opalrb.org/docs/generated_javascript/
[25]: http://rubyspec.org/
[26]: https://github.com/rubyspec/rubyspec/pull/270
[27]: https://github.com/opal/opal/pulls/chesterbr?direction=desc&page=1&sort=created&state=closed
[28]: http://www.ruby-doc.org/core-2.1.0/Fixnum.html#method-i-5B-5D
[29]: http://www.ruby-doc.org/core-2.1.0/Array.html#method-i-5B-5D-3D
[30]: http://www.ruby-doc.org/core-2.1.0/Fixnum.html#method-i-3C-3C

## Final observations

- Another minor change: `Cart` now can read the binary data of a cartdrige from an array. Ideally, I'd make it use an uploaded ROM file (since I don't intend to distribute those), but I'm not sure if that is feasible and just wanted to move on.

- Firefox renders at least 50% faster than Chrome - at least it did when I watched both running at the same time. I know, I know, this is as scientific as [Brazilian Bozo's Horse Race][19] (and not nearly as fun), but you can check by yourself.

(Chrome also crashed before the inevitable fall into the crocodile lake, while Firefox kept going. Your mileage may vary.)

**UPDATE**: Seven months later, Chrome reached Firefox in terms of speed, and both seem faster running the same code (which would likely also get improvements from newer Opal and fixes suggested on comments). It shows how both browsers are actively improving JavaScript execution performance - a great competition that benefits everyone!

- The [generated code][22] is interestingly reminescent of the [original][18] (after the Opal payload). This relationship is part of what makes it easy to mix Ruby and Javascript - a great Opal asset if used with moderation (as in the [current binding script][8]), but easily abused (like I did on the [first version][14]).

- Code for this proof-of-concept is (as of this writing) messy and depends on Opal merging [#507][20], but is [available as-is][18]. If anything, it convinced me that Opal is an interesting option among the myriad of [JavaScript alternatives][21] - in particular for Rubyists. I'll keep an eye on it.

[18]: https://github.com/chesterbr/ruby2600/pull/9
[19]: http://youtu.be/6VqG_C6G2HU?t=2m8s
[20]: https://github.com/opal/opal/pull/507
[21]: https://github.com/jashkenas/coffee-script/wiki/List-of-languages-that-compile-to-JS
[22]: /ruby2600/ruby2600.js
