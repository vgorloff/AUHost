//
// Application.swift
// AUHost
//
// Created by Vlad Gorlov on 05/10/2016.
// Copyright © 2016 WaveLabs. All rights reserved.
//

import Cocoa

class Application: NSApplication {

   override init() {
      super.init()
      delegate = self
   }

   required init?(coder: NSCoder) {
      super.init(coder: coder)
   }

   deinit {
   }
}

extension Application: NSApplicationDelegate {

   func applicationDidFinishLaunching(_: Notification) {
   }

   func applicationWillTerminate(_: Notification) {
      // Insert code here to tear down your application
   }

   func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
      return true
   }
}
