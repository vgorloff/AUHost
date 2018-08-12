//
// Application.swift
// AUHost
//
// Created by Vlad Gorlov on 05/10/2016.
// Copyright © 2016 WaveLabs. All rights reserved.
//

import Cocoa

class Application: NSApplication {

   private lazy var appMenu = MainMenu()
   private lazy var storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
   private lazy var mainWindowController = storyboard.instantiateInitialController() as? MainWindowController

   override init() {
      super.init()
      mainMenu = appMenu
      servicesMenu = appMenu.menuServices
      windowsMenu = appMenu.menuWindow
      helpMenu = appMenu.menuHelp
      delegate = self
   }

   required init?(coder: NSCoder) {
      fatalError()
   }

   deinit {
   }
}

extension Application: NSApplicationDelegate {

   func applicationDidFinishLaunching(_: Notification) {
      mainWindowController?.showWindow(nil)
   }

   func applicationWillTerminate(_: Notification) {
      // Insert code here to tear down your application
   }

   func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
      return true
   }
}
