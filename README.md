# AUHost.app

Standalone application which can load AudioUnits v3 PlugIns registered in the system.

## Playback engine Graph

Playback graph quite simple: `AudioFile > Effect (optional) > Main Output`.

## How to use Application

Application **Main** window has three tables with list of **Effects** and **Presets** and **Songs** from iTunes library.
Selecting **Effect** will insert it into playback graph.
Selecting **Preset** will activate corresponding **Factory** preset.

<img src="https://raw.githubusercontent.com/vgorloff/AUHost/master/Media/Screenshot-MainWindow.png" height="460" alt="Screenshot: MainWindow">

## Download

Signed and Notarized binary can be found at [Releases](https://github.com/vgorloff/AUHost/releases/latest) page.

## Requirements (for building)

- Xcode 13
