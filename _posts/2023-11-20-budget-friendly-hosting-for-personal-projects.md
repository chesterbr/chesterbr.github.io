---
layout: post
title: 'Budget-friendly hosting for personal projects'
og_image: /img/2023/11/build-server.jpg
description: "People get surprised when I tell them I keep all my personal software projects running on a single server, and that it costs me not much more than a cup of coffee per month. In this post I'll explain how I do it, and how you can do it too!"
comments: true
---

![UI button](/img/2023/11/build-server.jpg){: .right }

People get surprised when I tell them I keep all my personal software projects running on a single server, and that it costs me roughly a cup of (fancy) coffee per month. This post explains how I do it, and how you can do it too!

### Why bother?

Every now and then I build a personal project that requires hosting on a server - sometimes it's a [website](http://cruzalinhas.com/), sometimes a [back-end API](https://github.com/chesterbr/toronto-transit-time/tree/main/server#readme) for a [watchface](https://github.com/chesterbr/toronto-transit-time#toronto-transit-time), or even a [multiplayer game](https://github.com/chesterbr/minitruco-android/blob/main/README.md) server. In any case, it is tempting to use a free service or self-host, but eventually some of those prove to be useful to other people (or myself) on the long run, requiring a more robust solution.

Sure, one can always embrace the [DevOps](https://en.wikipedia.org/wiki/DevOps) culture and build the projects with [tooling](https://cloudblogs.microsoft.com/opensource/2019/07/15/how-to-get-started-containers-docker-kubernetes/) that describes their infrastructure needs in code, deploying on a cloud provider. That works, but comes with a price tag that might discourage building new projects, and you don't learn a lot about how things work behind the scenes.

In contrast, configuring and keeping a server up in a cost-effective, secure and robust way is a fun challenge in itself and a great learning experience. Even if you have a team or a service that does it all for you, getting some hands-on experience with servers makes you build better software, as you'll be more aware of the constraints and trade-offs involved when it is deployed.

<!--more-->

### Hosting strategies

There are many ways to host a project. Some of those are:

- **Self-hosting**: You run the server yourself, on your own hardware. It's cheap, but requires a good connection and a static IP address (or some shenanigans like [dynamic DNS](https://www.howtogeek.com/866573/what-is-dynamic-dns-ddns-and-how-do-you-set-it-up/)) and dealing with the physical aspects of a server. Currently I only use it for home automation stuff (which I run on a Raspberry Pi, which is silent and has modest space and power requirements). Can be fun to do for a while, but may become a chore, and I have enough of those at home.

- **Platform-specific solutions**: There are many services that allow you to host a project written in a specific technology (Java Web Applications and PHP-based sites come to mind); you just configure some things, drop your files there and your app is visible to the world. They are free/cheap for small projects, but can get expensive as things grow. I've used some of those in the past, but they don't fit the things I do nowadays (and are unlikely to fit new projects for anyone, as they are a bit out of fashion).

- **Serverless**: Instead of running a server, people that choose this route use a service that runs code on demand. I am skeptical of those in professional settings (where you can at least justify the gymnastics with the cost flexibility), but for personal projects it's just too much hassle (and often $) for too little benefit (unless your chosen tooling is already serverless).

- **Dedicated servers**: They are reliable, but buying or renting them is too expensive for personal projects, in particular because they will be underused - unless you intend to build your own personal cloud, but that isn't my case.

- **Containers**: As mentioned above, you can build your app with the likes of Docker and Kubernetes, and run it on a cloud provider. It is a good option for professional projects (and I particularly love the "[cattle, not pets](https://devops.stackexchange.com/questions/653/what-is-the-definition-of-cattle-not-pets)" approach), but it is overkill for personal ones, and it is a bit more expensive than the option below.

- **Virtual private servers**: On those, you rent a virtual machine (VM) from a provider. Like a dedicated server, you manage it yourself, but it is much cheaper (because you are sharing the hardware with other users). It is what I use for most of my projects, and I'll detail it below.

There are many VPS providers around, and it is tempting to go with the likes of Amazon Web Services (AWS) or Microsoft Azure, but they are overkill for personal projects. My VPS provider of choice is [DigitalOcean](https://www.digitalocean.com/) - besides the reliability and great tooling, they charge a fixed monthly rate for each "droplet" (their VMs) - which is important since any project may have an unexpected surge, and I'm not a startup that converts engagement into VC money.

It supports several Linux distributions and you can even supply your own, I suppose. I personally prefer [Ubuntu Server](https://ubuntu.com/download/server), as it builds upon the robustness, stability and familiarity of Debian but puts practicality above purity (e.g., by including non-free drivers and codecs by default). I use the [long-term support (LTS)](https://ubuntu.com/about/release-cycle) versions, so I can stay a few years just adding security patches, and rebuild the server from scratch when support ends or I need something from the newer versions - sounds radical, but is actually easy to do (more on that below).

### Domain names and HTTPS

In theory, you can just access the server's by typing its IP address on the browser (or client tool), but if you want to show it to others, it is *much* nicer to have a domain name. Some people like to register a domain for each hobby project (and for a few, registering domain names _is_ the hobby project). A more suitable route IMHO is to register a single domain (that represents you) and [use subdomains](https://hostadvice.com/blog/domains/wildcard-subdomain/) for the projects, which is what I do nowadays: I registered `chester.me`, and use the likes of `totransit.chester.me`, `minitruco.chester.me`, etc, for my projects.

A registrar is the company or entity that will register the domain name for you. Which one to choose depends on the domain-suffix, but my general go-to is [Dynadot](https://www.dynadot.com/), which is reasonably priced and has a nice user interface that allows you to easily direct all access to the server, or even fancier setups. For example, I pointed `chester.me` DNS entries to GitHub Pages, which hosts the blog you are reading right now, and all the subdomains to go to my DigitalOcean droplet.

Another reason to keep all your things on a single top-level domain is that it makes it easier to set up [encryption (https)](https://www.cloudflare.com/en-ca/learning/ssl/what-is-https/), which requires a [certificate](https://www.cloudflare.com/en-ca/learning/ssl/what-is-an-ssl-certificate/) for each domain. Having a single one, you can get a wildcard certificate for it, and use it for all subdomains (instead of registering a new one for each new project). You can and should get a free one from [Let's Encrypt](https://letsencrypt.org/) and use it with [Certbot](https://certbot.eff.org/), which automates the process of getting and renewing the certificates.

### Joining to conquer

Even with a cost-effective VPS, it is tempting to just go creating one server for each project, but that will become expensive pretty quickly, and here comes the main point of my personal project hosting strategy: **I host them all on a single (virtual) server**. Doing so allows me to share system resources, bandwidth and storage between projects (reducing the cost), and I can always split one of them to a new server if it grows too much or misbehaves.

The trick is to just configure them all on the same machine, each on a separate process (tree). Doing so is trivial for services that run on different ports, but even for those that run on the same port, I use [nginx](https://nginx.org/en/) as a reverse proxy to route requests to the right app.

For example, I have two apps that run internally on ports 3000 and 3001 (but you can't reach those ports externally, see the Security part below). Each of them has its own domain name, so it's easy to set up nginx to listen on the default web port (80) and route requests to the right app. For example, the configuration for one of the apps looks like this:

```nginx
# /etc/nginx/sites-available/cruzalinhas.com

# Define a new upstream server, which is the app running on port 3000
upstream cruzalinhas_rails { server 127.0.0.1:3000; }

# Requests to cruzalinhas.com...
server_name cruzalinhas.com;

server {

  # ...are forwarded to the upstream server defined above
  location ~ .* {
      proxy_pass http://cruzalinhas_rails;
  }
}
```

Other niceties that nginx provides are SSL termination (so you can have your apps "speak" plain HTTP, and it converts the incoming HTTPS requests from port 443 to HTTP requests to the upstream server), and the ability to serve static files (e.g., static HTML, images, video) directly, without having to go through the app. The [docs](https://nginx.org/en/docs/) show how to do it, but as you will see below, I use Ansible to automate most of those configs.

In order to keep those services alive, I use [Supervisor](http://supervisord.org/), a very configurable tool that allows you to start and stop your different projects, monitoring their processes and auto-(re)starting any of them as needed.

### Squeezing the most out of a single server: swapfile

The cheapest DigitalOcean droplets provide more than enough disk space and transfer bandwidth for my projects, but the memory is a bit tight. I could just upgrade to a more expensive droplet, but I found a better solution: a [swapfile](https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-20-04).

Usually sysadmins cringe at the idea of swap files on servers - I worked at places where they were forbidden, or where swap activity above a certain threshold would page the on-call person! For personal projects like mine, the server sits still most of the time, and the actual [working set](https://en.wikipedia.org/wiki/Working_set) of used RAM is much smaller than the allocated RAM, so it's 100% ok to let the allocated-but-unused pages swap out. On top of that, the "disk" is actually an SSD, so even if some swap activity happens, the performance hit isn't that bad, if perceptible at all.

You can start with the cheapest droplet, install your things and check `htop` to see how much physical memory is being used. If it is close to the limit, upgrade to the next tier (which is a matter of a few clicks on DigitalOcean's web interface), rinse, repeat. I have all my current projects (two active Rails apps and one Java multiplayer game server back-end) running their second-cheapest droplet, which has 1GB of RAM. It has a 2GB swapfile, rarely used above 10% and no [thrashing](https://en.wikipedia.org/wiki/Thrashing_(computer_science)) observed.

### Automated Provisioning

Sure, you can manually set up your server (and in fact you should do that every now and then for learning purposes, IMHO), but doing so it is not a good idea for a production environment: you may want to move to a different provider, or the server may crash and you'll need to set it up again, or you may want to split a project that grew too much into its own server... any of those things will require you to reconfigure from the start, and it's very likely that you will forget something.

One way of doing so is to have a shell script that contains all the commands you'd typically run to set up a server. That is better than nothing (and I've seen some startups doing that), but it has a few drawbacks: you need to handle secrets (e.g., passwords, API keys); if the config need changes, you need to manually reconfigure and keep the script updated (and likely can't run again on a production server); it gets complicated with different profiles (e.g., development vs production, or different apps); and so on.

A better approach is to use a tool that allows you to describe your server's configuration in a file, and then run that tool to set up the server. There are many tools for that, but I use [Ansible](https://www.ansible.com/). It is free and open-source, does not require installing anything on the server (it just needs SSH access), and is very flexible.

Ansible's central idea is that you describe your server's desired state in a YAML file containing all the configuration steps - this file is called a "playbook". A playbook can be written to be _idempotent_, that is, it can be run multiple times on an existing server, and it will only change what needs to be changed.

Most important: those configuration steps are not unlike the commands you'd manually issue (they are only wrapped in so-called "tasks", which automate all that checking). Even if there isn't a task for a given command, you can always run a shell command directly (as long as you ensure it is idempotent, as described above).

For example, my server has a [`provisioning.yml`](https://github.com/chesterbr/chester-ansible-configs/blob/8cb0146dfffedc6c0136976f58d85bd5d87b6ee9/provisioning.yml) playbook that [sets up the necessary Unix users](https://github.com/chesterbr/chester-ansible-configs/blob/main/roles/chesterbr.user_setup/tasks/main.yml) (both mine for manual ssh-ing, and the ones needed by application servers), [tightens the security](https://github.com/chesterbr/chester-ansible-configs/blob/main/roles/chesterbr.security/tasks/main.yml) of the server and does some [additional configuration](https://github.com/chesterbr/chester-ansible-configs/blob/main/roles/chesterbr.swapfile/tasks/main.yml).

It also has one playbook for each specific project (e.g., [this one](https://github.com/chesterbr/chester-ansible-configs/blob/main/cruzalinhas.yml) that sets up a Ruby on Rails app, which installs the necessary packages, sets up the database, installs the app, and so on). Sure, right now all my apps run on the same server, but if I ever need to split one of them, I can just provision the new server and run the playbook for the new app.

The best thing is that spinning a new server is easy and non-disruptive. For example, when I want to upgrade Ubuntu to a new version (usually a risky operation in any operating system or distribution), I just create a new droplet on DigitalOcean and run the playbooks on it. Then I edit my local `/etc/hosts` file and point all subdomains to the new server's IP (from the point of view of my computer) and test it. Once I'm sure it's working fine, I revert that edit, flip the DNS to the new server and destroy the old one.

### App deployment

Each tech stack has its own way of deploying and redeploying apps; quite a few have more than one blessed way. You have to consider things like how much downtime your project can tolerate between deploys; whether you need to preserve any state (data, connections) between deploys, and so on.

For personal projects, I try to make the simplest possible thing that works. For example, most of my Rails-based apps just update the code on the server straight from GitHub (the existing instance won't be affected by that, as the code is already loaded and production configs don't auto-reload) and restart it.

For the game server, I needed to do a more complex [script](https://github.com/chesterbr/minitruco-android/blob/d5fee6c0b5c6c194e670ad3a7ad82cfbc055e764/launcher.sh) that starts the server software, then monitors its `.jar` file for changes. When it happens, the script instructs the running server to stop responding to connections, and immediately start another process with the new version (which accepts all new connections). Meanwhile, the old server drops any player that isn't currently on a game until no one is left, then finishes itself. In practice, that gives everyone the opportunity to finish their games, while anyone not in a game just connects to the new server, with no downtime or interrupted games.

### Security

When you manage your own server, it's important to keep it secure. There are many things you can do, but here are some of the most important ones:

- Disable root login and password authentication for any user (they should always use SSH keys);
- Configure some form of auto-update (Debian/Ubuntu have `unattended-upgrades`, but you need to configure it to actually apply the updates; I recommend just focusing on security ones here, and manually update playbooks or rebuild the server on a new OS version for everything else);
- Enable a software firewall (I recommend `ufw`, which is a friendly wrapper for Linux' built-in packet filtering), only allowing inbound traffic on the necessary ports. My provisioning playbook opens ports 22 (SSH), 80 (HTTP) and 443 (HTTPS), and any app that needs a different port will have that configured in its own playbook;
- Add additional security software. I like `fail2ban`, which automatically blocks IPs that try to brute-force SSH or HTTP logins by using the same firewall structure managed by `ufw`, thus adding no additional load to the server.

You can see these configs on the [security part](https://github.com/chesterbr/chester-ansible-configs/blob/8cb0146dfffedc6c0136976f58d85bd5d87b6ee9/roles/chesterbr.security/tasks/main.yml) of my provisioning setup.

Keep in mind your apps' needs (for example, when opening the port used by my multiplayer game server on `ufw`, I also had to [increase](https://github.com/chesterbr/chester-ansible-configs/blob/8cb0146dfffedc6c0136976f58d85bd5d87b6ee9/minitruco.yml#L46-L55) `fail2ban`'s allowance for multiple connections from the same IP, because it is reasonable that friends playing together may be using the same Wi-Fi network and have the same external IP). Always go with closed stuff by default, and opening on a case-by-case basis.

If you tighten it enough, the next vector for security issues will be... your own code! Aside from the usual security best practices (e.g., sanitizing user input), you should also keep your dependencies up to date. Keeping the code on [GitHub](https://github.com/) allows [Dependabot](https://docs.github.com/en/code-security/dependabot) to check for that in supported languages (and even suggest updates), and the tooling there will also monitor for leaked secrets (e.g., API keys) and alert you if it finds any. As a former GitHub employee I may be biased, but I can't recommend it enough.

### Keeping your server alive

It isn't a home banking system, yet you want the service to stay alive when you sleep. I already mentioned Supervisor above, but other small things worth considering are:

- **Log rotation**: You don't want your server to run out of disk space because of logs. I use `logrotate` to avoid that; it has sensible defaults but is easy to [customize](https://github.com/chesterbr/chester-ansible-configs/blob/8cb0146dfffedc6c0136976f58d85bd5d87b6ee9/templates/minitruco_logrotate.conf.j2).
- **Monitoring**: This is one I haven't done as well lately, but it's a good idea to have. For webservers, a good idea is to add an endpoint that does whatever basic checks you think reasonable (e.g., get something from the database) and responds with, say an "OK", then have a service call it every few minutes and alert you when it doesn't respond. [UptimeRobot](https://uptimerobot.com/) offers free checks every 5 minutes, which should be enough for a personal project.

### User data

Honestly, having any sort of persistent data in a personal project is a hassle - both from a technical perspective (you have to back it up, you have to take it with you when you rebuild your server, etc.) and from a legal perspective (you have to comply with privacy laws, etc.). It's ok to have persisted data, as long as you can easily rebuild and start anew.

If you really need a database for important data, consider those operations when choosing. For example, SQLite is easy to back up (it's just a file) *if* you can stop the server - or at least writes - during backups (otherwise you risk copying a corrupt backup); MySQL has more backup options, but you need to set them up. An external service like Amazon RDS or DigitalOcean's Managed Databases may be a good idea, but it will add to the cost.

Whatever you choose, make sure you restore the backups when provisioning a new server, and **test the backups** from time to time, not only when you need them. In fact, if you restore when provisioning, a good (and cheap) test is to just provision a new server and see if the data is there. The only caveat is that once you confirm it is fine, users may have written new data to the soon-to-become old server, so you'll likely need some downtime to make a new backup/restore cycle... as I said, avoid this at all costs!

### Secrets (and non-secrets)

 My server configuration is [published on GitHub](https://github.com/chesterbr/chester-ansible-configs). It may sound reckless, but [good security should never be done by obscurity](https://en.wikipedia.org/wiki/Security_through_obscurity); instead, it gives the good guys a chance to alert me about bad practices, while not showing much that the bad guys couldn't find out by themselves. Please check it for details on the techniques I describe here.

Things that should actually be kept secret can be stored in [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html), which encrypts them with a password that you supply when running the playbooks, or in some service like [GitHub Secrets](https://docs.github.com/en/actions/reference/encrypted-secrets), that are only visible to the repository owner (but they require some GitHub Actions gymnastics for provisioning into a server, which is why I currently stay with Ansible Vault).

### Final thoughts

This isn't a universal guide on how to host personal projects - but rather a description of how have been doing it (which I may update as I find or remember other interesting things), and how other people can do it too.


