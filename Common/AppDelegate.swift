//
//  AppDelegate.swift
//  AUHost
//
//  Created by Vlad Gorlov on 21.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

   override init() {
      super.init()
   }

   deinit {
   }

   func applicationDidFinishLaunching(_ aNotification: Notification) {
   }

   func applicationWillTerminate(_ aNotification: Notification) {
      // Insert code here to tear down your application
   }

   func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
      return true
   }

}
