---
layout: post
title: "Voice control for a non-smart TV (with Google Home, a Raspberry Pi, LIRC, nginx, Lua and IFTTT)"
date: 2017-12-12 12:00
og_image: /img/2017/12/multi_led.jpg
description: "Teaching voice tricks to an old TV and sound bar requires some hacking, but pays off nicely."
comments: true
categories:
---

Despite my privacy concerns, I could not resist the [low price](https://mobilesyrup.com/2017/11/23/google-canada-home-mini-black-friday-2017/) of the Google Home Mini. It is _really_ convenient to control the ChromeCast with it, but turning my (non-smart) TV on/off, or switching the input between different devices still required reaching the remote...

...until I hacked a bit!

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/S36R4uajkzA" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe></center>

In a nutshell: IFTTT turns Google Home commands into HTTPS requests towards a Raspberry Pi. There, nginx triggers some Lua code that runs LIRC, which generates IR signals into a transistor that amplifies them to two IR LEDs. Complicated, but it works!

<!--more-->

### Hardware: Raspberry Pi + IR LED (+ a few extras)

TVs with HDMI-CEC [can be controlled and input-switched](https://support.google.com/googlehome/answer/7498991?hl=en-CA) by Google Home via ChromeCast. Mine doesn't, so I resorted to something that could duplicate the (IR) light signals emitted the remote control.

Sure, I could just add an [IR LED](https://www.creatroninc.com/product/lte-5208-infrared-emitter-940nm/?search_query=lte-5208&results=3) to an Arduino or a Raspberry Pi (with a resistor, just like we do with regular LEDs on those ["blinking LED" tutorials](https://learn.adafruit.com/adafruit-arduino-lesson-2-leds/blinking-the-led)). But I liked [this simple circuit](http://www.raspberry-pi-geek.com/Archive/2015/10/Raspberry-Pi-IR-remote) that strengthens the signal just by adding a transistor and second resistor, and went with it for my initial breadboard experiment:

![initial prototype](/img/2017/12/prototype.jpg){: .center }

Once I realized that I also wanted to control my sound bar, the transistor paid off: I just add a second LED in parallel, and it worked with decent signal strength.

The final version had the components soldered on a tiny piece of protoboard, small enough to fit inside the Raspberry Pi case. The IR LEDs were soldered to 22 AWG black wire, which stays in place when twisted and blends well with the black TV and sound bar.

![final, multi-led version](/img/2017/12/multi_led.jpg){: .center }

### IR programming: LIRC

One reason I chose a Raspberry Pi over an Arduino was [LIRC](http://www.lirc.org/), an open-source IR remote control software. It took some time to install, because most [tutorials](http://alexba.in/blog/2013/01/06/setting-up-lirc-on-the-raspberrypi/) don't include the ([Raspbian](https://www.raspberrypi.org/downloads/raspbian/)-specific) step of editing `boot/config.txt`. The following line must be uncommented and the pin must be the one connected to the 10K resistor:

```
dtoverlay=lirc-rpi,gpio_out_pin=22
```

Another hurdle: LIRC's [remotes database](http://lirc-remotes.sourceforge.net/) did not include either my TV or my sound bar, so I had to create configuration files for them.

To do so, I added an infrared receiver ([TSOP38238](https://www.adafruit.com/product/157)) to another pin (pinout [here](http://www.raspberry-pi-geek.com/Archive/2014/03/Controlling-your-Pi-with-an-infrared-remote)), adding it as a `gpio_in_pin` at all places that I previously added the IR led as `gpio_out_pin`.

With this new (and temporary) hardware setup, [`irrecord`](http://www.lirc.org/html/irrecord.html) guided me into pressing each button on the remote and generating a config file. The TV remote was straightforward, but the IR bar one required raw mode (`-f`), then converting the results to regular codes (`-a`).

It was a bit tedious, so I sent the files to the database maintainer for the benefit of future owners of those devices. Until they actually publish it (or in case that they never do), here are my remote code files:

- [Sharp LCDTV 845-039-40B0 TV](https://gist.github.com/chesterbr/1aab4045db0dc029c41207fb395bbd6c)
- [Insignia NS-SB314 Sound Bar](https://gist.github.com/chesterbr/f8fddc43bf7d28dc1c865de71dca939e)

With these in place, I could submit commands such as:

```
irsend SEND_ONCE Sharp_LCDTV-845-039-40B0 KEY_MENU
```

and see the menu appearing on the TV, just as if I had pressed the `MENU` key.

![final, multi-led version](/img/2017/12/menu.jpg){: .center }

The source switching was another challenge: my TV requires entering an input menu, navigating with arrows and pressing enter. But I could pack the sequence of `irsend` commands (with proper `sleep`s to give the slow TV time to react) in a script, like this:

```
irsend SEND_ONCE Sharp_LCDTV-845-039-40B0 INPUT
sleep 1.5
irsend SEND_ONCE Sharp_LCDTV-845-039-40B0 KEY_UP
sleep 0.5
irsend SEND_ONCE Sharp_LCDTV-845-039-40B0 KEY_UP
sleep 0.5
irsend SEND_ONCE Sharp_LCDTV-845-039-40B0 KEY_ENTER
```

It wasn't over yet: the number of `KEY_UP`s for a given input depends on which one is already selected. The final solution involved using the `KEY_PC` button (which switches the VGA input) and using that as a starting point. Not super fast, but works.

### Opening (safely) to the outside world: nginx

![initial prototype](/img/2017/12/mini.jpg){: .right }

The other reason I chose a Raspberry Pi for the project was that the commands from IFTTT would come as web requests.

Security is always a concern with outside requests, so trusty [nginx](https://www.nginx.com/) was the tool for the job. Once you properly [secure your Raspberry Pi](https://www.raspberrypi.org/documentation/configuration/security.md), it can be installed with:

```
sudo apt-get install nginx
```

I had to forward ports 80 and 443 from my router to the Pi (also giving it a permanent IP lease), then opening the same ports on `ufw` (you _did_ enable the Linux firewall when you secured it, right?), allowing requests to [my current IP](https://www.whatismyip.com/) to reach nginx.

Adding a dynamic DNS service (such as [no-ip](https://www.noip.com/free)) and an ssl certificate (either a [self-signed](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04) one or - my favorite option - a fully trusted one with [Let's Encrypt](https://letsencrypt.org/)) allowed the the Pi to respond at a fixed URL with full TLS ("https") encryption.

Hardening the configuration with something like this (in `/etc/nginx/sites-enabled/my.domain`, where `my.domain` is the domain from the dynamic DNS provider) makes both myself and [security checkers](https://www.ssllabs.com/ssltest/) happy:

```
server {
  listen 80;
  listen 443 ssl;
  listen [::]:443 ssl;

  ssl_certificate /etc/letsencrypt/live/my.domain/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/my.domain/privkey.pem;

  ssl_session_timeout 1d;
  ssl_session_cache shared:SSL:50m;
  ssl_session_tickets off;

  ssl_protocols TLSv1.1 TLSv1.2;
  ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256';
  ssl_prefer_server_ciphers on;

  # HSTS (ngx_http_headers_module is required) (15768000 seconds = 6 months)
  add_header Strict-Transport-Security max-age=15768000;

  # OCSP Stapling ---
  ssl_stapling on;
  ssl_stapling_verify on;

  error_page 500 502 503 504 /500.html;
  client_max_body_size 4G;
  keepalive_timeout 10;

  if ($request_method !~ ^(GET|HEAD|PUT|PATCH|POST|DELETE|OPTIONS)$ ){
    return 405;
  }
  ...
```

### Triggering the IR from the web: Lua

In the Apache days, I'd set it up CGI scripts and be done with it, but nginx [doesn't support that](https://serverfault.com/a/274770/42428). To my surprise, [Raspbian Stretch Lite](https://www.raspberrypi.org/downloads/raspbian/) came with [Lua](https://www.lua.org/) - a nifty scripting language, perfect for the job at hand! All I had to do was to add this module:

```
sudo apt-get install libnginx-mod-http-lua
```

and I could add some scripting in the same config file where I set up the server:

```
location /remote {
  lua_need_request_body on;
  content_by_lua_block {
    local args, err = ngx.req.get_post_args()
    if not args then
      return
    end
    if args["secret-key"] ~= "some_generated_secret" then
      return
    end
    if args["action"] == "tv_power" then
      os.execute("irsend SEND_ONCE Sharp_LCDTV-845-039-40B0 KEY_POWER");
...
    elseif args["action"] == "soundbar_volume_up" then
      os.execute("irsend SEND_ONCE Insignia_RMC-SB314 KEY_VOLUMEUP");
...
    end
  }
}
```

With this, an HTTPS POST message containing the `secret-key` and the `action` triggers the remote. The secret key will be fully encrypted within the message payload, keeping it safe.

It can be tested with `curl`:

```
curl -d "secret-key=some_generated_secret&cmd=soundbar_volume_up" https://my.domain/remote
```

### Putting it all together: IFTTT

![IFTTT example](/img/2017/12/ifttt_example.png){: .left }

[IFTTT](https://ifttt.com/) ("IF This, Then That") is a neat website that executes actions ("that") in response to triggers ("this").

You can tell it to do things like "if I receive an email from this address, then post the contents on Facebook", or "if the stocks for company XYZ change, add the value to a Google Spreadsheet". It is only limited by the available services (but there are [a lot](https://ifttt.com/search) of them).

By using [Google Assistant](https://ifttt.com/google_assistant) as a trigger and [Maker Webhooks](https://ifttt.com/maker_webhooks) as an action, it was super easy to trigger the HTTPS endpoint defined above by a voice command.

I just [created a new applet](https://ifttt.com/create) ("applet" is how IFTTT calls the "if this then that" statements), picking Google Assistant as "this". After a quick, first-time-only setup it allowed me to tell what phrase(s) will trigger the command and what Google Home should say.

For "that", I chose Webhooks, using `application/x-www-form-urlencoded` for Content Type, `POST` for method and the arguments of the `curl -d` command above (minus quotes) as body and URL, respectively.

Created an applet for each desired command, and that was it, done. Look ma, no hands!
