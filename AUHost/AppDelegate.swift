//
//  AppDelegate.swift
//  AUHost
//
//  Created by Vlad Gorlov on 21.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

   var mediaLibraryLoader = MediaLibraryUtility()
   var playbackEngine = PlaybackEngine()

   func applicationDidFinishLaunching(_ aNotification: Notification) {
   }

   func applicationWillTerminate(aNotification: Notification) {
      // Insert code here to tear down your application
   }

   func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
      return true
   }

}
