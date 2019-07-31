---
layout: post
title: "(Cheap) 433Mhz Leak Detectors in Home Assistant via Arduino + OpenMQTTGateway (with Telegram alerts)"
date: 2019-07-30 23:00
og_image: /img/2019/06/arduino_assembled.jpg
description: "A hacky but low-cost way of getting notifications on my phone if a pipe bursts while I'm away."
comments: true
categories:
---

Water incidents in a condo can be catastrophic, and surely things like shutting your main water valve when you go out for long periods and having the proper coverage in your insurance are important. But for added peace of mind, leak detectors aren't a bad idea.

When I saw these [$3 leak detectors](https://www.ebay.com/itm/302368775388) on eBay, I decided to give them a shot. Not only for low price, but also because they used 433Mhz RF - the same tech I use to [voice-control my lights from a Raspberry Pi](https://chester.me/archives/2017/12/controlling-rf-outlets-from-a-raspberry-pi/).

![](/img/2019/06/sensor_open.jpg){: .center }

Once they arrived, I ran `RFSniffer` and indeed, when they get wet, the Raspberry Pi prints a different value for each sensor - so it should be easy to wire up an alert system... _right?_

<!--more-->

### MQTT

Well, it wasn't. I found it odd that [Home Assistant](https://www.home-assistant.io/) doesn't have a 433MHz input integration (despite having a few for output). The reason is that "sniffing" from Raspbian can be clunky (you need a daemon running) and unreliable (due to its non-realtime nature).

[technicalpickles](https://technicalpickles.com/) suggested I should check out [MQTT](http://mqtt.org/), so I did. It is a "publish/subscribe message transport" - something I'm familiar with (having worked with a few pub-sub systems, including the venerable IBM MQSeries [from which the "MQ" in "MQTT" comes](https://en.wikipedia.org/wiki/MQTT)), but honestly, it felt like over-engineering at first.

Eventually, I realized it is more of a divide-and-conquer approach, with these parts:

- A "broker" software that sits in the middle of everything.
- A dedicated device that monitors the RF frequency and publishes events to this broker when a sensor "says" it's wet.
- A Home Assistant integration that subscribes to these events and triggers automations to notify me.

Splitting things like that (and using MQTT as the glue) means I don't have to write _any_ new software:

- [Moskitto](https://mosquitto.org/) is an MQTT broker that runs on the Pi and requires no configuration at all.
- [OpenMQTTGateway](https://github.com/1technophile/OpenMQTTGateway) transforms Arduino-compatible devices in monitors for all sorts of inputs (including our 433Mhz RF), publishing  their signals as MQTT events into a broker.
- Home Assistant has an [MQTT integration](https://www.home-assistant.io/components/mqtt/) that, once properly configured, consumes events from a broker and exposes them as [sensors](https://www.home-assistant.io/components/sensor/).

### Assembling the monitor/publisher

I got a new [Arduino Uno](https://store.arduino.cc/usa/arduino-uno-rev3/) for the project (my other Arduino clones/models lacked the memory requirements for OpenMQTTGateway). Since it needs to send the events to the network, I added an [Ethernet Shield](https://www.amazon.ca/dp/B00HG82V1A/ref=pe_3034960_236394800_TE_dp_1), and for RF I used my newest [Long Range 433Mhz RF Receiver module](https://www.dx.com/p/open-smart-long-range-433mhz-rf-wireless-transceiver-kit-for-arduino-2004619#.XT5sQCUpCtE). The long range and built-in antenna made this my receiver of choice over the [more popular](https://www.dx.com/p/rf-transmitter-receiver-module-433mhz-wireless-link-kit-w-spring-antennas-for-arduino-2057011#.XT5tMiUpCtF) RF modules - and it's just as cheap as those.

By bending the data output pin on the RF receiver a little bit, the receiver can be inserted directly on the shield, just matching the VCC and GND pins with the 5V and GND holes (respectively). The data pin can be then connected to Arduino digital input 3 hole with a small [breadboard jumper wire](https://www.dx.com/p/diy-male-to-female-dupont-breadboard-jumper-wires-black-multi-color-40-pcs-10cm-2045521#.XT5t8yUpCtE).

The final result is a bit taller than I wished, but hey, no soldering required:

![](/img/2019/06/arduino_assembled.jpg){: .center }

### Mosquitto MQTT broker configuration

Assuming you are using [Raspbian Buster](https://www.raspberrypi.org/downloads/raspbian/) or later, just log on the Pi and type:

```shell
sudo apt-get install mosquitto mosquitto-clients
```

and you are good. Seriously, that's it.

Technically you just need the `mosquitto` package, but the other one allows you to test your installation by running:

```shell
mosquitto_sub -t \# -v
```

which prints all messages published to the broker. You can publish a message by opening a second terminal window and running a command like this:

```shell
mosquitto_pub -t "some/test/topic" -m "hi this is the message"
```

The first terminal will show `some/test/topic hi this is the message`, indicating `hi this is the message` was published under the topic `some/test/topic`.

### OpenMQTTGateway configuration

This project's [wiki](https://github.com/1technophile/OpenMQTTGateway/wiki) contains several configuration guides, including [one for my setup](https://github.com/1technophile/OpenMQTTGateway/wiki/Arduino-RF-Send-and-Receive), that is, an Arduino reading RF signals and publishing to a MQTT broker.

Here are the changes I made to [User_config.h](https://github.com/1technophile/OpenMQTTGateway/blob/development/main/User_config.h) (after downloading [the "CODE-" release](https://github.com/1technophile/OpenMQTTGateway/releases) and moving the `lib` folder as explained on the wiki):

- After `DEFINE THE MODULES YOU WANT BELOW`, uncomment (that is, remove the `//` from):

```c
#define ZgatewayRF     "RF"       //ESP8266, Arduino, ESP32
```

- Leave all other `##define Z...` lines commented (with `//`).

- In the line `char mqtt_server[40] = "..."`, put the IP address of the Raspberry Pi (between the quotes).

- Replace the zeros in the line `const byte ip[] = { 0, 0, 0, 0 }; //ip adress` with an IP address for the Ethernet Shield that is compatible with the network (even though the comments say the software supports DHCP, it wasn't working for me).

- **IMPORTANT**: Uncomment the line below so each sensor publishes events to a specific MQTT topic (instead of a single topic for all of them, which results in a barrage of `No matching payload found for entity: ... with state_topic: ...'`).

```c
#define valueAsASubject true
```

Uploading a sketch with those changes will make the Arduino connect to your broker. If you still have `mosquitto_sub -t \# -v` open, you should see something like:

```
home/OpenMQTTGateway/LWT online
home/OpenMQTTGateway/version 0.9.1
```

and whenever a sensor gets wet:

```
home/OpenMQTTGateway/433toMQTT/VALUE {"value":VALUE,"protocol":...,"length":...,"delay":...}
```

where `VALUE` is (hopefully) unique for each of your sensor. In fact, you'll see those events for all other things transmitting in the 433MHz frequency in your vicinity. I get a couple every minute in my apartment.

### Home Assistant

First thing is to make Home Assistant aware of your new broker. You can do it on the UI (clicking on `+`, selecting "MQTT" and setting `localhost` as the broker address), or by adding to `configuration.yaml`:

```yaml
mqtt:
  broker: IP_ADDRESS_BROKER
```

That will make Home Assistant subscribe to the broker, but you need to expose the events. There are two ways:

- Use the [MQTT Trigger](https://www.home-assistant.io/docs/automation/trigger/#mqtt-trigger) and directly trigger actions when events for a specific topic (sensor) are published.
- Use the [MQTT Binary Sensor](https://www.home-assistant.io/components/binary_sensor.mqtt/) to represent the actual state of the sensors in the UI.

The trigger was tempting for my goal (getting notifications on my computer/phone when a potential leak is detected), but putting the sensors in the UI allows for richer integrations with other elements in the home. It also allows configuring fine details - for example, defining that a sensor is "on" when you get the message, but only gets "off" after X seconds without a message, so I went with it.

Just add these values to `configuration.yaml`, one `-` session for each sensor (replacing "11111111", "22222222", etc. with the `VALUE`s from `mosquitto_sub` or `RFSniffer`):

<!-- {% raw %} -->
```yaml
binary_sensor:
  - platform: mqtt
    name: Washroom Leak Sensor
    payload_on: "11111111"
    value_template: "{{ value_json.value }}"
    off_delay: 10
    device_class: moisture
    state_topic: "home/OpenMQTTGateway/433toMQTT/11111111"
  - platform: mqtt
    name: Kitchen Sink Leak Sensor
    payload_on: "22222222"
    value_template: "{{ value_json.value }}"
    off_delay: 10
    device_class: moisture
    state_topic: "home/OpenMQTTGateway/433toMQTT/22222222"
  - platform: mqtt
    name: Some Other Leak Sensor
    ...
```
<!-- {% endraw %} -->

Once you restart, the sensors should be available in your Home Assistant main dashboard. I manually config mine, so I built a nice little card with them:

![](/img/2019/06/home_assistant_sensors.png){: .center }

The page updates dynamically, so you should see them flip as you wet the sensors, then go back after 10s (or how many you set the `off_delay` above):

![](/img/2019/06/home_assistant_sensors_wet.png){: .center }

### Notifications via Telegram

No one looks at a dashboard all the time (well, **I** don't 😁), so we need a way to send notifications to my mobile phone. The [Telegram integration](https://www.home-assistant.io/components/telegram/) is a great way to do it.

Just open [BotFather](https://telegram.me/botfather) on the app, send it a `/newbot` command to create a bot for you, and get its `TOKEN`. Send any message to the newly-created bot, then visit `https://api.telegram.org/botTOKEN/getUpdates` (replace `TOKEN` accordingly) to get the `ID` of your personal user for that bot.

Then add these lines to `configuration.yaml`, replacing `TOKEN` and `ID` with yours.

```yaml
telegram_bot:
  - platform: polling
    api_key: TOKEN
    allowed_chat_ids:
      - ID
notify:
  - name: my_telegram
    platform: telegram
    chat_id: ID
```

Another Home Assistant restart, and you should be able to send messages to your Telegram app by clicking on "Services" and calling `notify.my_telegram` with something like `{ "message": "hi" }`. The result:

![](/img/2019/06/telegram.png){: .center }

### Wiring it all together

The grand finale: sending the notification when a sensor gets on (wet) or off (dry). Here is where Home Assistant shines - something like this in `automations.yaml` does the trick:

<!-- {% raw %} -->
```yaml
- alias: kitchen_sink_leak_sensor_state_change_alert
  trigger:
    platform: state
    entity_id: binary_sensor.kitchen_sink_leak_sensor
  action:
    service: notify.my_telegram
    data:
      message: "Kitchen Sink Leak Sensor is {{ states('binary_sensor.kitchen_sink_leak_sensor') }}"
```
<!-- {% endraw %} -->

Had to add one for each sensor, but it was worth it. Here is my phone, telling me I should check the pipes under my sink:

![](/img/2019/06/sensor_message_on_phone.png){: .center }

How cool is that? Not at all? Well... _I_ find it cool. 🤓

### Possible improvements

I'm quite happy with the results, but some things might be improved:

- The sensors aren't bad for their price, but I found that often batteries can get displaced (depending on how you hang the sensor's main unit). If I keep working with those, I may consider some adaptation to the case (for now, some tape did the trick).
- The Arduino + Ethernet shield are a good option if you have them lying around. But an [ESP8266](https://en.wikipedia.org/wiki/ESP8266) would likely be a better choice, with its built-in Wi-Fi, small size and [ridiculous price](https://www.dx.com/p/nodemcu-lua-esp8266-wifi-development-board-2607279#.XUD5JCUpCtE).
- I use the Raspberry Pi to control [my TV with an IR blaster](https://chester.me/archives/2017/12/voice-control-for-a-non-smart-tv-with-google-home-raspberry-pi-lirc-nginx-lua-ifttt/) and [lights using 433MHz RF outlets](https://chester.me/archives/2017/12/controlling-rf-outlets-from-a-raspberry-pi/), which require some software setup that often breaks as Raspbian and Home Assistant get updates. Maybe I could offload those functions to the Arduino (or ESP8266).
