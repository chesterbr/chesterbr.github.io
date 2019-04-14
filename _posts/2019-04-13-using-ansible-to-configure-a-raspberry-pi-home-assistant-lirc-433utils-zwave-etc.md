---
layout: post
title: "Using Ansible to configure a Raspberry Pi (Home Assistant, LIRC, 433Utils, Z-Wave, etc.)"
date: 2019-04-13 17:00
og_image: "/img/2019/04/raspberry-pi-with-ir-blaster-rf-transmitter.jpg"
description: ""
comments: true
categories:
---

A while ago I built a couple inexpensivehacks that added [voice-command to my tv]({% post_url 2017-12-10-voice-control-for-a-non-smart-tv-with-google-home-raspberry-pi-lirc-nginx-lua-ifttt %}) and then [to my lights]({% post_url 2017-12-26-controlling-rf-outlets-from-a-raspberry-pi %}) using a Raspberry Pi, Google Home Mini, infrared and RF radio. Since then, I added other things, which prompted me to move the hacks into the popular [Home Assistant](https://www.home-assistant.io/) home hub software.

With so much of my routine depending on that setup, backup became a concern. I'd make an occasional copy of the SD card with `dd`, but that isn't a good long-term solution. Ideally, I wanted to rebuild my setup easily, should the card get corrupt, slow or just wrecked by my ongoing hacking.

![](/img/2019/04/raspberry-pi-with-ir-blaster-rf-transmitter.jpg){: .center }

Enter [Ansible](https://github.com/ansible/ansible). Sysadmins use it to write "playbooks" that represent the changes they would manually apply to a server. If done right, such playbooks can be applied to an existing server (fixing any broken configs), or a brand new one (to recreate its services).

The Raspberry Pi is just a (tiny) server - meaning hobbyists can use Ansible as well!

I'm not an Ansible expert (there are [better](https://www.packtpub.com/books/info/authors/jesse-keating) [places](https://www.ansiblefordevops.com/) to learn about it), but [my Ansible configs](https://github.com/chesterbr/chester-ansible-configs#home-automation-raspberry-pi) and these notes may be useful for anyone interested in automating Raspberry Pi setups (for home automation or anything else).

<!--more-->

### The general idea (TL;DR)

Raspberry Pi setup is typically done by [downloading Raspbian](https://www.raspberrypi.org/downloads/raspbian/) and [writing it to a (micro)SD card](https://www.balena.io/etcher/). I usually download the latest "Lite" version, so I can install just what I need and keep it snappy.

With that as a starting point, I created two Ansible playbooks:

- The [provisioning playbook](https://github.com/chesterbr/chester-ansible-configs/blob/master/rpi_provisioning.yml) uses the default "pi" user to configure the hostname and create a new, better-secured user. It grabs the public SSH keys from my GitHub account, ensuring only the person with matching private keys (myself) can access it.
- The [main playbook](https://github.com/chesterbr/chester-ansible-configs/blob/master/rpi.yml) uses the new user to further harden the security, then configure all the things I need on my Pi (infrared, RF, Z-Wave utilities, Home Assistant, [Let's Encrypt](https://letsencrypt.org/) certificates, [DuckDNS](https://www.duckdns.org/) updates, etc.).

The main playbook can be ran as many times as needed - it will only configure things that aren't already set up (Ansible peeps call that an "idempotent playbook", I've heard).

### Secrets and Home Assistant

Every server needs a couple passwords and keys, and since my playbooks are public, I encrypt those secrets using [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html). That works nicely for everything... except Home Assistant.

In theory, you can provide Home Assistant secrets [on a separate file](https://www.home-assistant.io/docs/configuration/secrets/) and just encrypt it, provision manually, etc. [I have tried that](https://github.com/chesterbr/chester-ansible-configs/blob/f3012060c69a02d895b07fb95a921dc003615ecc/rpi.yml#L230-L244), but every time I built the system from zero, I realized something was stored outside the standard config files (e.g., logins), or even scattered in binary datafiles (dynamic device information, some configs made on the UI, etc.).

After lots of frustration, I went with a different plan: I set up [an encrypted daily backup](https://github.com/chesterbr/chester-ansible-configs/blob/23cbf9fa96f36587ea48155ce77ae13dd6dd795a/templates/ha-backup.sh.j2#L17-L25) of the Home Assistant configuration to a network drive (just a thumb drive on my router), and made the playbook [restore the latest backup](https://github.com/chesterbr/chester-ansible-configs/blob/23cbf9fa96f36587ea48155ce77ae13dd6dd795a/templates/ha-backup.sh.j2#L5-L14) when a config-less install is detected.

The main downside is that my automations aren't easily shared. But I can always write a post if I ever come with something useful (so far, they are all pretty boring 😅).

### Why don't you reuse roles from [Ansible Galaxy](https://galaxy.ansible.com/)?

What a _horrible_ programmer I must be, because, you know, reuse is good™️... right? 😁

I tried to use Ansible Galaxy. Really. But the roles I found were often not generic enough (like _almost_ doing what I wanted) and don't always support Raspbian. Galaxy also lacks a robust package management system (which may not even be feasible, given the free-form, "script-y" nature of Ansible that I like so much), so I went solo.

Of course I took inspiration in a lot of third party roles and playbooks (on Galaxy and around the web), and highly recommend doing so.

### Why don't you just use [Hass.io](https://www.home-assistant.io/hassio/)?

Good question! Hass.io is a prebuilt SD card image that manages a minimal OS with Home Assistant baked in, automatically updated with Docker.

I personally found it a bit too slow (at least on earlier-gen Raspberry Pi models), and I feel more comfortable with a Debian-based system that I can poke with a stick. But hey, all the cool kids are using Docker 😜. Seriously though, if it works for you, awesome - you'll save yourself a lot of trouble.

The automatic Home Assistant updates are appealing, but with my solution, I can just axe the application directory (or the whole SD card, for the matter) and run the playbook, and the latest version will be there, with my configs unchanged.

### Wait, so you do things on the Pi _without_ Ansible? Won't your changes be overwritten when you run it?

**Oh yes I do!** With gusto. The main point of having a custom-made solution (other than cost and security) is tinkering. Ansible makes me confident that I can rebuild the whole thing quickly if I screw up, but yes, that requires me to keep the Ansible file up-to-date.

That's actually easier than it sounds: once I'm happy with my changes, I type `history` and figure which steps (installed packages, changed config files) are _really_ needed, and add those to the playbook. Run it a few times, undo some changes, check that it does nothing when changes are already there... and that's it.

If the change was super complex and/or I'm afraid I forgot something, I can always run the playbooks against a fresh card, pop it in and kick the tires - it's a great opportunity to get a fresh, snappy OS install for my tiny computer!
