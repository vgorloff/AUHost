# AUHost

[![Build Status](https://travis-ci.org/vgorloff/AUHost.svg?branch=master)](https://travis-ci.org/vgorloff/AUHost)

## AUHost.app

Standalone application which can load AudioUnits v3 PlugIns registered in the system.

#### Playback engine Graph

Playback graph quite simple: `AudioFile > Effect (optional) > Main Output`.

#### How to use Application

Application **Main** window has three tables with list of **Effects** and **Presets** and **Songs** from iTunes library.
Selecting **Effect** will insert it into playback graph.
Selecting **Preset** will activate corresponding **Factory** preset.

<img src="https://raw.githubusercontent.com/vgorloff/AUHost/master/Media/Screenshot-MainWindow.png" height="460" alt="Screenshot: MainWindow">

## Build system and Deployment target requirements

- Xcode 11.5

