---
layout: post
title: "Enable dynamic DNS (DynDNS, Duck DNS, etc.) inside networks without NAT loopback support on router"
date: 2019-08-18 23:45
description: "TL;DR: install dnsmasq with custom entry, configure devices to use it"
comments: true
categories:
---

Dynamic DNS providers like [DynDNS](https://dyn.com/dns/) or [Duck DNS](https://www.duckdns.org) are great to let you access software like [Home Assistant](https://www.home-assistant.io/) running on your [properly secured](https://www.raspberrypi.org/documentation/configuration/security.md) computer or Raspberry Pi from anywhere.

One problem that I was having with them: the custom URL did not work _inside_ my network, just outside. That happens because my router does not support [NAT loopback](https://en.wikipedia.org/wiki/Network_address_translation#NAT_loopback), blocking any requests from the internal network to the external IP (which is what my custom domain points to).

<!--more-->

On a computer, it is easy to fix. Let's assume your custom domain is `foobar.duckdns.org`, and the _internal_ IP (the one you configured the router to forward a given port to) is 1.2.3.4 (replace in all commands here). Adding a line like this to `/etc/hosts` (and commenting it out if the computer ever leaves the house) does it:

```
foobar.duckdns.org 1.2.3.4
```

For mobile devices, it isn't so easy: Neither Android, nor iOS expose the `/etc/hosts` file. And those will enter and leave the house all the time, which would make it impractical.

Easy solution: since I already have a Raspberry Pi lying around, I installed `dnsmasq` on it:

```bash
sudo apt-get install dnsmasq
```

and opened the firewall for its port, so my mobile devices can use that DNS when they are inside the network:

```bash
sudo ufw allow dns
```

Several online tutorials suggest config changes (such as enabling DHCP - a no-no for my otherwise working network). I just kept the default and added this line to `/etc/dnsmasq.conf` and restarting the service:

```
address=/foobar.duckdns.org/1.2.3.4"
```

With that, the DNS server will respond with the internal IP for the custom domain:

```bash
$ dig @1.2.3.4 foobar.duckdns.org

; <<>> DiG 9.10.6 <<>> @1.2.3.4 foobar.duckdns.org
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 10291
;; flags: qr aa rd ra ad; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;foobar.duckdns.org.         IN      A

;; ANSWER SECTION:
foobar.duckdns.org.  0       IN      A       1.2.3.4

;; Query time: 50 msec
;; SERVER: 1.2.3.4#53(1.2.3.4)
;; WHEN: Sun Aug 18 23:36:59 EDT 2019
;; MSG SIZE  rcvd: 66
```

and everything else will go to the normal DNS server for normal resolution:

```bash
$ dig @1.2.3.4 google.com

; <<>> DiG 9.10.6 <<>> @1.2.3.4 google.com
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 55137
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             171     IN      A       172.217.165.14

;; Query time: 51 msec
;; SERVER: 1.2.3.4#53(1.2.3.4)
;; WHEN: Sun Aug 18 23:37:11 EDT 2019
;; MSG SIZE  rcvd: 55
```

The final step was to edit the Wi-Fi connection on the devices. iOS was the easiest: you can just click `Configure DNS`, switch to `Manual`, remove the auto-configured value(s) and add `1.2.3.4`. Android requires you to change the whole `IP settings` to `Static` and enter the information (which also means you'll need an IP assigned to your mobile phone on your router).

But that is a minor nuisance that I only had to set up once. After that, the devices work inside and outside the house (which is great for Home Assistant, in particular if you have security things you want to check from away). The downside: if the Pi is down, the devices won't have internet (which is why I kept the computer on the '/etc/hosts' solution), but you can always switch back (or to data) if that happens. Overall, I'm happy now.
