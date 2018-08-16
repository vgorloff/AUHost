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
   private lazy var windowController = MainWindowController()

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
}

extension Application: NSApplicationDelegate {

   func applicationDidFinishLaunching(_: Notification) {
      windowController.showWindow(nil)
   }

   func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
      return true
   }
}
