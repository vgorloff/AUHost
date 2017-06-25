# AUHost

[![Build Status](https://travis-ci.org/vgorloff/AUHost.svg?branch=master)](https://travis-ci.org/vgorloff/AUHost)

## Purpose

Apple supplied sample code [AudioUnitV3Example](https://www.google.com/search?q=AudioUnitV3Example+site:apple.com) quite *messy* as it contains C++, C, Obj-C++, Swift code at once.  
I faced *weird* issues while translating sample code to pure Swift. Such as missed `mData` pointers in buffer lists, In-Place processing behaviour and absence of Software for testing. At least for now (2016 Oct) AULab does not support AUv3.

[AudioUnitV3Example](https://www.google.com/search?q=AudioUnitV3Example+site:apple.com) also does not explain how to build PlugIn which is not pure DSP unit, but for instance Visualiser (Level meter, Oscilloscope, etc.).

## Build system and Deployment target requirements

- **Xcode 9 (Swift 4)**
- iOS 9, macOS 10.11
- Metal

## AUHost.app

This is a standalone application which can load any AudioUnits v3 PlugIns registered in the system.

#### Playback engine Graph

Playback graph quite simple: `AudioFile > Effect (optional) > Main Output`.

#### How to use Application

Application has **Main** window and floating **Media Library** panel.  
You are using **Media Library** panel to drag and drop media files into **Main** window. It is possible also drag files from **Finder**.

**Main** window has two tables with list of **Effects** and **Presets**.
Selecting **Effect** will insert it into playback graph.  
Selecting **Preset** will activate corresponding **Factory** preset.


<img src="https://raw.githubusercontent.com/vgorloff/AUHost/master/Media/Screenshot-MediaLibrary.png" height="460" alt="Screenshot: MediaLibrary">&nbsp;
<img src="https://raw.githubusercontent.com/vgorloff/AUHost/master/Media/Screenshot-MainWindow.png" height="460" alt="Screenshot: MainWindow">

## Attenuator.app

This is a Hosting application with embedded Extension. Hosting application dynamically registers AttenuatorAU AudioUnit and loads it In-Process.   AttenuatorAU extension registered by the system and available for any AudioUnit v3 hosts (such as AUHost.app).

**Note**: You must move application to `/Applications` folder in order to inform system to perform `AttenuatorAU.appex` registration.

#### Playback engine Graph

Playback graph quite simple: `AudioFile > AttenuatorAU Effect (unloadable) > Main Output`.

#### How to use Application

Application has **Main** window and floating **Media Library** panel.  
You are using **Media Library** panel to drag and drop media files into **Main** window. It is possible also drag files from **Finder**.

**Main** window has two buttons and two areas (**Media Item View** and AttenuatorAU **User Interface**).
Pressing **Load AU** will insert AttenuatorAU into playback graph.   Pressing **Unload AU** will remove AttenuatorAU from playback graph.

## AttenuatorAU.appex

It is a AudioUnit v3 AudioUnit which can be loaded by any AudioUnit v3 host (such as AUHost.app).  

It has two areas: *funny* **Level Meter** and **Gain** control.  
Volume level meter uses Metal 3D graphics engine for rendering signal volume in **funny** way.  
Gain control used to control DSP engine of AudioUnit PlugIn. Under the hood it bound to multiplication coefficient used to in functions from Accelerate framework.

<img src="https://raw.githubusercontent.com/vgorloff/AUHost/master/Media/Screenshot-Attenuator.png" height="600" alt="Screenshot: Attenuator">
