# WindowsIoTEverywhere
Windows 10 IoT running on off-the-shelf tablets, mini-pcs, and various computers. 
The Goal is to find a few off-the-shelf devices that work well and bring together everything needed for an average dev can get them working immediately. 
This repository will host images that can be flashed, drivers that are found to be compatiable, and document devices we've tested.
It is equally importnat to document devices that worked and devices that didn't. 

## Motivation
Windows IoT Core, unlike "Normal" Windows, does not carry a metric ton of crap from paleolithic era, and unlike Linux it has a good UI system and driver ABIs. This makes it great for use in single-purpose devices, such as kios apps, signage, Iot devices and robots.
You might protest that off -the shelf devices don't have GPIOs, but one can use a microcontroller over USB.

Currently Microsoft provides images for three boards, and all of them have issues or suck for anything beyong a hobby project. 
Window IoT core can be run on off-the-shelf computers, But all the documentation is meant for OEMs. You have to be knowledgeable about drivers and even then it's days of mucking about, It's a terrible pain. Even then, everyone is duplicating effort and wasting time. let's pool our efforts. 

## Tested devices
### Legend

* ✔️ - Works
* ❌ - Doesn't Work
* 🔘 - No such capability on device
* ❔ - Untested

| Device            | Chipset       |UEFI|Boot|GPU| WiFi | BLE | Sound | Mic | Touch | Camera | 
| ------------------|---------------|----|----|---|------|-----|-------|-----|-------|--------|
| Compute Stick     | Atom® x5-Z8300| 32 |✔️  |❌| ✔️   |✔️  | 🔘    | 🔘 | 🔘   | 🔘     |
| Compute Stick     | Atom Z3735F   | 32 |✔️  |✔️| ✔️   |✔️  | 🔘    | 🔘 | 🔘   | 🔘     |
| Tablet Linx1010   | Atom Z3735F   | 32 |✔️  |✔️| ✔️   |✔️  | ✔️    | ✔️ | ✔️   | ❔      |
| Tablet Chuwi Hi10 | Atom Z8300    | 64 |❔   |❔ | ❔   |❔   | ❔     | ❔  | ❔   | ❔      |
| Jumper EZpad 6 Pro| Celeron N3450 | ❔ |❔   |❔ | ❔   |❔   | ❔     | ❔  | ❔    | ❔     |




