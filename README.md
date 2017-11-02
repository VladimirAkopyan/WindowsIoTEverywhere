# WindowsIoTEverywhere
Windows IoT running on off-the-shelf tablets, mini-pcs, and various computers. Many off-the-sheld devices are compatiable with Windows IoT Core, but it uses a more resticted driver model. The only way to find out which ones are compatiable is to test them
The Goal is to find a few off-the-shelf devices that work well and bring together everything needed for an average dev can get them working immediately. 

This repository will host images that can be flashed, drivers that are found to be compatiable, and document devices we've tested.
It is equally important to document devices that worked and devices that didn't. 

## Motivation
Windows IoT Core, unlike "Normal" Windows, does not carry a metric ton of crap from paleolithic era, and unlike Linux it has a good UI system and driver ABIs. This makes it great for use in single-purpose devices, such as kios apps, signage, Iot devices and robots.
You might protest that off -the shelf devices don't have GPIOs, but one can use a microcontroller over USB.

Currently Microsoft provides images for three boards, and all of them have issues or suck for anything beyong a hobby project. 
Window IoT core can be run on off-the-shelf computers, But all the documentation is meant for OEMs. You have to be knowledgeable about drivers and even then it's days of mucking about, It's a terrible pain. Even then, everyone is duplicating effort and wasting time. let's pool our efforts. 

## High-level overview
Intel IoT core will boot on most UEFI systems. A 32 bit UEFI will boot 32 bit Windwos IoT, and 64 bit UEFI can only boot 64 bit Windows IoT. This is not the case with "normal" operating systems- they would boot either way. 
Currently MIcrosoft only provides 32 bit image of Windows IoT for Minnowboard Max, and if you wish to test it on another machine, you have to build an image yourself, the process is described in [Windwos IoT Core Build your own image section](https://docs.microsoft.com/en-us/windows/iot-core/). 

Currently Intel provides board support packages for Atom BayTrail and Atom Apollo Lake prossesors. Cherry Trail Intel Atom prossesors are not supported. 
A device with unsupported prossesor would still boot up, but GPU acceleration won't work, and some peripherals won't work either. A Cherry Trail (Atom® x5-Z8300) Intel Compute Stick is one example of such device. This device may still be usefull for some purposes. 

# How to test a device
## Backup Drivers
First see what kind of device you are runnning. You need to get 32 bit drivers for 32 bit Windows Iot, and 64 bit drivers for 64 bit Iot. Use PowerShell to export drivers from your device while it's running "normal" Windows.
```PowerShell
Export-WindowsDriver -Online -Destination C:\driversBackup
```
Save them somewhere safe, we will need them later. 

## Create bootable flashdrive
Then you need to [create a bootable flashdrive that runs Windows PE](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive). To do that, download [Windwos DeploymentKit](https://developer.microsoft.com/en-us/windows/hardware/windows-assessment-deployment-kit#winADK) and tick  Windows PE. 
Take a flashdrive and format it as FAT32 (NTFS should work too). Then open "Deployment and Imaging Tools Environment" and type in 
```POweShell
copype amd64 C:\WinPE_amd64
```
amd64 can be replaced with x86 or ARM as needed. Change file path as needed too. 
Then take contents of `C:\WinPE_amd64\media` and copy them to your formatted flash drive. That's it, you have a bootable drive! NO special magic needed. 
Don't forget that for 32 bit devices you need to create a bootable flash drive with x86 version of Windows PE, and for x64 you need x64 version. 
Next take JouleInstaller.cmd from this repository, it is a program that will flash a WindowsIoT image (FFU) onto the device drive, and it's avaliable from this repo. 
Last thing to do is to get the right FFU and to place it in the root of the flashdrive. 

## Getting the FFU
If it's a Bay trail device, it will probably have a 32 bit UEFI, and you can go ahead and flash a MinnowBoard Max image by following [Instruction for Intel Compute Stick](https://developer.microsoft.com/en-us/windows/iot/Docs/GetStarted/IntelComputeStick/GetStartedStep1.htm) 

If it's a different device, it will probably be running a 64 bit UEFI and you need to [build a 64 bit version of Window IoT](https://docs.microsoft.com/en-us/windows/iot-core/build-your-image/createbsps). Then it can be flashed by, again, following Instructions for Intel Compute stick linked above. 



Once your device boots up, you find it's IP address using a Windows IoT Dashboard. That will let you login to a web portal and manage the device. If your device has no connectivity, get a USB2 Ethernet-to-USB adapter, most of them work out of the box even with Windows IoT. 

Remotely connect to your device through PowerShell - 

https://docs.microsoft.com/en-us/windows/iot-core/connect-your-device/powershell

Althought you can build the drivers into the image, that's a time-consuming process. 


## Goals
* Document which devices work and which don't. What works and what doesn't
* Provide x86 and x64 apollo lake Images for quick testing of devices, so everyone doesn't have to download 50 metric tons of stuff just to test their device
* Provide drivers
* Provide fully built images for each device 

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
| ECDream DreamOne  | Celeron N3450 | ❔ |❔   |❔ | ❔   |❔   | ❔     | ❔  | ❔    | ❔     |
| PIPO X10pro       | Atom Z8330    | ❔ |❔   |❔ | ❔   |❔   | ❔     | ❔  | ❔    | ❔     |




