# AUHost

[![Build Status](https://travis-ci.org/vgorloff/AUHost.svg?branch=master)](https://travis-ci.org/vgorloff/AUHost)

## Application for hosting AudioUnits v3 using AVFoundation API

**Note**: AVFoundation API for using AudioUnits v3 available starting from `iOS 9` and `OS X 10.11`.  
**Note**: In order to use make custom build and use sandboxed application (with underlying PlugIn and XPC subsystem) it is required to sign it with code sign certificate. If you have no Apple Developer ID (and code sign certificate), then download and use existing [binary](https://github.com/vgorloff/AUHost/releases).

## Playback engine Graph

Playback graph quite simple: `AudioFile > Effect (optional) > Main Output`.

## How to use Application

Application has **Main** window and floating **Media Library** panel.  
You are using **Media Library** panel to drag and drop media filed into **Main** window. It is possible also drag files from **Finder**.

**Main** window has two tables with list of **Effects** and **Presets**.
Selecting **Effect** will insert it into playback graph.  
Selecting **Preset** will activate corresponding **Factory** preset.

--

<img src="https://raw.githubusercontent.com/vgorloff/AUHost/master/Screenshot-MediaLibrary.png" height="460" alt="Screenshot: Posts">&nbsp;
<img src="https://raw.githubusercontent.com/vgorloff/AUHost/master/Screenshot-MainWindow.png" height="460" alt="Screenshot: Friends">
