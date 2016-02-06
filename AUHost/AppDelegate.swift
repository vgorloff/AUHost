//
//  AppDelegate.swift
//  AudioUnitExtensionDemo
//
//  Created by Vlad Gorlov on 21.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Cocoa
import WLCore
import WLMedia

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var mediaLibraryLoader = MediaLibraryUtility()
	var playbackEngine = PlaybackEngine()

  func applicationDidFinishLaunching(aNotification: NSNotification) {
		Logger.sharedLoggerProperties.logAsynchroniously.value = false
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }

  func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
    return true
  }
  

}

