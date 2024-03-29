---
layout: clean
title: miniTruco Privacy Policy
---
## miniTruco Privacy Policy

_Last revision: Aug 10, 2023_

### Introduction

[miniTruco](https://github.com/chesterbr/minitruco-android) is an open-source card game which can be played on a single device, on multiple devices via Bluetooth, or connected to an internet server to play with other people.

It is a not-for-profit game, with no advertising or fees, developed as a hobby project with my personal resources to give people a free game to play.

This page/document details how the game, the server and the author handle your data and your privacy - the general goal is to collect as little data as possible to enable the game to be playable. I encourage you to review it before downloading or playing the game, in order to decide if its policies suit you and your jurisdiction.

### Data collected

- When you are playing a local or Bluetooth game, no internet connection is made, and thus no data is collected.
- When you click on the "Internet" button, the server will receive your nickname (if you supplied one), and, due to the nature of how internet connections work, the Internet Protocol (IP) address supplied by your ISP at the moment. This IP address is solely used for connection purposes and is not stored or associated with any other personally identifiable information.
- As you play a game, the game session (the cards each player has seen and what they played on their turn) is also recorded on the same logs.

### Data *not* collected

- No user accounts, user profiles, logins, emails, passwords or any likewise information is ever requested or collected.
- No other data about you, your device, your accounts is ever requested or collected.
- Any user preferences are stored solely on the device, using the device's supplied APIs. No data from other applications is collected by the app.

### Data storage
- A log line is recorded on a log file on each relevant game event (for example: entering a room, starting a game, playing a card, disconnecting).
- Raw logs are kept for no longer than 30 days (possibly less than that, as it's a server with limited capabilities) and never leave the server.
- Game sessions (without nickname and IP) may be indirectly stored for longer as they are used to train bots (see below), but not on that server, not in a format that can be associated with an individual or any demographics.

### Data security
- The server where the data is stored (and the game is played) runs on a modern Linux-based system, configured with a software firewall, and automatic installation of security updates.
- While the communication between the client and the server is not encrypted, the only information that goes through that channel are nicknames and game sessions; neither can be used to identify an individual, a device, or demographics (since nicknames are not unique and are redefined on every session, and game sessions are restricted to fixed actions).
- All other access to the server (deployments, automated configuration, and manual diagnostics) run over encrypted connections (SSH with encrypted keys), following best practices to protect against unauthorized access and theft of data.

### Data usage
- Debugging game sections in order to fix bugs and assist players having problems.
- Potentially improving the game "bots" (used when there are not enough human players, or when not connected to a server or other device) by using game sessions above (without nickname or IP, just the cards played) to train or assist in coding their algorithm.
- In the future, the app may allow other users to "watch" games being played on the server (live or past games). In that case, those watcher users will only be able to see the nicknames and game sessions, but no IPs or any sort of identifying information.

### Auditing
The behaviour above can be audited by anyone by examining [source code of the game server](https://github.com/chesterbr/minitruco-android/tree/main/server) and the [server provisioning configuration](https://github.com/chesterbr/chester-ansible-configs/blob/main/minitruco.yml).

### Further information

In case you have any questions, please feel free to contact the author using the mechanisms provided either on the app, or the marketplace/"app store" where the game was downloaded.

<br/>

<p align="right"><i>Carlos Duarte do Nascimento</i><br/><i>creator and maintainer of <a href="https://github.com/chesterbr/minitruco-android">miniTruco</a></i></p>
