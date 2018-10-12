//
// Application.swift
// Attenuator
//
// Created by Vlad Gorlov on 05/10/2016.
// Copyright © 2016 WaveLabs. All rights reserved.
//

import Cocoa

class Application: NSApplication {

   private lazy var appMenu = MainMenu()
   private lazy var window = Window(contentRect: CGRect(width: 320, height: 280), style: .fullSizeContent)
   private lazy var windowController = WindowController(window: window, viewController: viewController)
   private lazy var viewController = MainViewController()

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
      viewController.viewModel.mediaLibraryLoader.loadMediaLibrary()
      if #available(OSX 10.12, *) {
         window.tabbingMode = .disallowed
      }
      windowController.showWindow(nil)
   }

   func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
      return true
   }
}
