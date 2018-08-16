//
//  MainWindowController.swift
//  AUHost
//
//  Created by Vlad Gorlov on 22.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

   private lazy var mainStoryboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)

   private lazy var customWindow = NSWindow(contentRect: CGRect(x: 196, y: 240, width: 480, height: 270),
                                            styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: true)

   private lazy var mainViewController = MainViewController()
   private let viewUIModel = MainViewUIModel()
   private let mainToolbar = MainToolbar(identifier: NSToolbar.Identifier("ua.com.wavelabs.AUHost:mainToolbar"))
   private lazy var mlController: NSMediaLibraryBrowserController = configure(NSMediaLibraryBrowserController.shared) {
      $0.mediaLibraries = [NSMediaLibraryBrowserController.Library.audio]
   }

   init() {
      super.init(window: nil)
      customWindow.toolbar = mainToolbar
      window = customWindow
      contentViewController = mainViewController
      setupUI()
      setupHandlers()

      mainViewController.uiModel = viewUIModel
      viewUIModel.mediaLibraryLoader.loadMediaLibrary()
   }

   override func showWindow(_ sender: Any?) {
      super.showWindow(sender)
   }

   required init?(coder: NSCoder) {
      fatalError()
   }
}

extension MainWindowController {

   private func setupUI() {
      customWindow.autorecalculatesKeyViewLoop = false
      customWindow.title = "Window"
      if #available(OSX 10.12, *) {
         customWindow.tabbingMode = .disallowed
      }
   }

   private func setupHandlers() {
      viewUIModel.mediaLibraryLoader.eventHandler = { [weak self] in
         switch $0 {
         case .mediaSourceChanged:
            self?.mlController.isVisible = true
         }
      }
      mainToolbar.eventHandler = { [unowned self] in
         switch $0 {
         case .toggleMediaLibrary:
            self.mlController.togglePanel(self)
         case .reloadPlugIns:
            self.viewUIModel.reloadEffects()
         }
      }
   }
}
