---
layout: post
title: "Enable dynamic DNS (DynDNS, Duck DNS, etc.) inside networks without NAT loopback support on router"
description: "TL;DR: install dnsmasq with custom entry, configure devices to use it"
comments: true
categories:
---

Dynamic DNS providers like [DynDNS](https://dyn.com/dns/) or [Duck DNS](https://www.duckdns.org) are great to let you access software like [Home Assistant](https://www.home-assistant.io/) running on your [properly secured](https://www.raspberrypi.org/documentation/configuration/security.md) computer or Raspberry Pi from anywhere.

One problem that I was having with them: the custom URL did not work _inside_ my network, just outside. That happens because my router does not support [NAT loopback](https://en.wikipedia.org/wiki/Network_address_translation#NAT_loopback), blocking any requests from the internal network to the external IP (which is what my custom domain points to).

<!--more-->

On a computer, there is an easy fix. Let's assume your custom domain is `foobar.duckdns.org`, and the _internal_ IP (the one that you configured the router to forward a given port to) is 1.2.3.4. Adding a line like this to `/etc/hosts` (and commenting it out with `#` if the computer ever leaves the house) does it:

```
foobar.duckdns.org 1.2.3.4
```

For mobile devices, it isn't that easy: neither Android, nor iOS expose `/etc/hosts`. And those devices enter and leave the house all the time, making it impractical anyway.

The workaround: since I already have the Raspberry Pi lying around, I installed `dnsmasq` (a lightweight DNS server) on it:

```bash
sudo apt-get install dnsmasq
```

and opened the firewall for its port, so my mobile devices can use that DNS when they are inside the network:

```bash
sudo ufw allow dns
```

Several online tutorials suggest config changes (such as enabling DHCP on `dnsmasq` - a no-no for my otherwise working network). I just kept the default config and added this line to `/etc/dnsmasq.conf` and restarting the service:

```
address=/foobar.duckdns.org/1.2.3.4"
```

With that, the DNS server will respond with the internal IP for the custom domain:

```bash
$ dig @1.2.3.4 foobar.duckdns.org

; <<>> DiG 9.10.6 <<>> @1.2.3.4 foobar.duckdns.org
...
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 10291
;; flags: qr aa rd ra ad; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
...
;; ANSWER SECTION:
foobar.duckdns.org.  0       IN      A       1.2.3.4
...
```

and everything else will go to the normal DNS server for normal resolution:

```bash
$ dig @1.2.3.4 google.com

; <<>> DiG 9.10.6 <<>> @1.2.3.4 google.com
...
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 55137
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
...
;; ANSWER SECTION:
google.com.             171     IN      A       172.217.165.14
...
```

The final step was to edit the Wi-Fi connection on the devices, so they would ask `dnsmasq` for names when inside the network. iOS was the easiest: you just click `Configure DNS`, switch to `Manual`, remove the auto-configured value(s) and add `1.2.3.4`. Android requires changing the whole `IP settings` to `Static` (which also means you'll need an IP assigned to your mobile phone on your router) and enter the information manually.

But that is a minor nuisance (that I only had to go through once). After that, the devices work inside and outside the house (which is great for Home Assistant, in particular if you have security things you want to check from away). The downside: if the Pi is down, the devices won't have internet (which is why I kept the computer on the '/etc/hosts' solution), but you can always switch back (or to data) if that happens. Overall, I'm happy now.
