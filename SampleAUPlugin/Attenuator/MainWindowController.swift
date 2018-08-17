//
//  MainWindowController.swift
//  Attenuator
//
//  Created by Vlad Gorlov on 06/10/2016.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

   private lazy var customWindow = NSWindow(contentRect: CGRect(x: 196, y: 240, width: 480, height: 270),
                                            styleMask: [.titled, .closable, .miniaturizable, .resizable],
                                            backing: .buffered, defer: true)

   private lazy var mediaLibraryBrowser = configure(NSMediaLibraryBrowserController.shared) {
      $0.mediaLibraries = [.audio]
   }

   private lazy var viewController = MainViewController()
   private lazy var mainToolbarID = NSToolbar.Identifier("ua.com.wavelabs.Attenuator:mainToolbar")
   private lazy var mainToolbar: MainToolbar = MainToolbar(identifier: self.mainToolbarID, showsReloadPlugInsItem: false)

   init() {
      super.init(window: nil)
      customWindow.toolbar = mainToolbar
      window = customWindow
      contentViewController = viewController

      setupUI()
      setupHandlers()

      viewController.viewModel.mediaLibraryLoader.loadMediaLibrary()
   }

   required init?(coder: NSCoder) {
      fatalError("Please use this class from code.")
   }
}

extension MainWindowController {

   private func setupUI() {
      if #available(OSX 10.12, *) {
         customWindow.tabbingMode = .disallowed
      }
   }

   private func setupHandlers() {
      mainToolbar.eventHandler = { [weak self] in
         switch $0 {
         case .toggleMediaLibrary:
            self?.mediaLibraryBrowser.togglePanel(nil)
         case .reloadPlugIns:
            break
         }
      }
      viewController.viewModel.mediaLibraryLoader.eventHandler = { [weak self] in
         switch $0 {
         case .mediaSourceChanged:
            self?.mediaLibraryBrowser.isVisible = true
         }
      }
   }
}
