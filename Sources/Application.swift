//
// Application.swift
// AUHost
//
// Created by Vlad Gorlov on 05/10/2016.
// Copyright © 2016 WaveLabs. All rights reserved.
//

import Cocoa
import mcxUIReusable

class Application: NSApplication {

   private lazy var windowController = FullContentWindowController(contentRect: CGRect(width: 500, height: 460),
                                                                   titleBarHeight: 30, titleBarLeadingOffset: 7)
   private lazy var appMenu = MainMenu()
   private lazy var viewController = MainViewController()
   private lazy var titleBarController = TitlebarViewController(isHostTitleBar: true)

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
      titleBarController.eventHandler = { [weak self] in
         switch $0 {
         case .effect:
            self?.viewController.toggleEffect()
         case .library:
            self?.viewController.toggleSongs()
         case .play:
            self?.viewController.viewModel.togglePlay()
         case .reloadPlugIns:
            self?.viewController.viewModel.reloadEffects()
         }
      }
      viewController.viewModel.eventHandler = { [weak self] in
         self?.viewController.handleEvent($0, $1)
         self?.titleBarController.handleEvent($0, $1)
      }
      viewController.viewModel.mediaLibraryLoader.loadMediaLibrary()
      if #available(OSX 10.12, *) {
         windowController.content.window.tabbingMode = .disallowed
      }
      windowController.embedContent(viewController)
      windowController.embedTitleBarContent(titleBarController)
      windowController.showWindow(nil)
   }

   func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
      return true
   }
}
