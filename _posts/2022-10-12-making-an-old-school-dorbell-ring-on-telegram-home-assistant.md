---
layout: post
title: 'Making an old-school doorbell "ring" on Telegram/Home Assistant'
og_image: /img/2022/10/
description: "A circuit that detects the 12V AC doorbell and triggers Home Assistant via an ESP8226 (Wemos D1 Mini) and ESPHome"
comments: true
---

After years of living in single-room condos, we decided to try a more spacious, two-store house, which has a very old and low-tech doorbell: a button on the door triggers a "ding-dong" classic doorbell - very easy to miss if you are on the upper floor, causing all sorts of issues with deliveries.

Sure, I could make it ring louder, but it would be annoying for anyone on the lower floor. And I also want to automate other hurdles related to package delivery, so I decided to first get the  doorbell to ring into my [Home Assistant](https://www.home-assistant.io/) setup (where I can trigger all sorts of automations).

### ACϟDC 🤘

The easiest thing would be to replace the front door pushbutton with a four-contact one (so it would close the doorbell circuit and mine); but this being a rental discourages me from doing outdoors modifications; instead I got my trusty multimeter to pry into the doorbell, and found that when the doorbell rings, a ~12V AC current flows through the exposed contacts.

That kind of signal isn't good to trigger my home automation stuff, which usually relies on Arduino/Raspberry Pi/etc. GPIO pins. After some searching I found an anonymous suggestion of a [circuit](https://forum.arduino.cc/t/sensing-12v/202885/3) that _pulls down_ (connects to GND) a GPIO pin whenever a current is present. Here is a reproduction of the circuit:

...img of circuit

My understanding/learning is that the "+" and "-" refer to one of the phases of the alternating current (AC): the capacitor charges up during that phase; when it flips the diode prevents current from flowing and the capacitor discharges. The resulting current is now direct (DC), and is fed into the opto-coupler - a package that contains an LED that triggers a photo-sensitive transistor, effectively triggering the GPIO pin when there is current, but keeping it completely isolated. 🏆

### Try before you buy

Before progressing further, I decided to test the circuit above on a breadboard, using an Arduino and a slightly modified version of the `02-Digital/Button` example that comes with the Arduino IDE that pulls up the pin and flips the built-in LED when it is pulled down, that is, when the doorbell rings:

...img of breadboard/arduino

```c
void setup() {
  Serial.begin(9600);
  pinMode(2, INPUT_PULLUP);
  pinMode(13, OUTPUT);
}

void loop() {
  int sensorVal = digitalRead(2);
  Serial.println(sensorVal);
  if (sensorVal == HIGH) {
    digitalWrite(13, HIGH);
  } else {
    digitalWrite(13, LOW);
  }
}
```

And it works! Now it's about figuring out how to bring that signal to Home Assistant...

### Wemos D1 Mini and ESPHome

I could connect that circuit to the Raspberry Pi 3B+ that runs my Home Assistant, but, as I said, it's a big house, so I got a [WeMos D1 Mini](https://makersportal.com/blog/2019/6/12/wemos-d1-mini-esp8266-arduino-wifi-board) - a cheap and tiny ESP8266-based board that, in short, behaves like an Arduino with built-in Wi-Fi.

[In the past](https://chester.me/archives/2019/07/cheap-433mhz-leak-detectors-home-assistant-arduino-openmqttgateway-telegram-alerts/) I used the [OpenMQTTGateway](https://github.com/1technophile/OpenMQTTGateway) software to turn such boards into sensors and triggers. But as much as I love the community around that software, its source-code-based approach and reliance on MQTT makes it quite hard to set up and update.

Enter [ESPHome](https://esphome.io/), which is focused on Home Assistant and thus _much_ easier to work with: you just configure what your sensor needs to do in a tiny YAML file straight from Home Assistant; it builds the firmware and updates it (wirelessly and very securely once you set up the first time via USB).

### Building for real now

I know, all the cool kids either make their own PCBs, or design them and use one of the small-volume PCB services that sponsor half of the YouTube electronics videos. Not wanting to deal with the chemicals and iterate quickly, I went to my custom solution of cutting a piece of perfboard and doing the connections with solder and, when needed, jumpers.

After botching a first attempt (in which I just threw the components at Fritzing's Breadboard view), I realized I could reproduce the circuit on the Schematic view, and get all the components connected on the Breadboard view, where I could just lay them out on a perfboard ("Stripboard" component) and figure the needed solder/jumper points, error-free - not unlike people use the PCB view to design their boards, I suppose.

... image of the Breadboard

I used a white 5V USB charger to power the boards, sticking them with mount tape to the side of the charger (which will be facing down and thus invisible when plugged in).

... image of the finished thing

A pair of white wires connects this to the doorbell. It's not the most finished setup, but it is discreet enough to be ignored (in particular because there are several other white cables running over those walls) and easy to remove when I return this rental.

### Making it sing

