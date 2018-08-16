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

   private lazy var mainViewController = ViewController()

   private lazy var mlController: NSMediaLibraryBrowserController = configure(NSMediaLibraryBrowserController.shared) {
      $0.mediaLibraries = [NSMediaLibraryBrowserController.Library.audio]
   }

   let mainToolbarID = NSToolbar.Identifier("ua.com.wavelabs.Attenuator:mainToolbar")
   lazy var mainToolbar: MainToolbar = MainToolbar(identifier: self.mainToolbarID, showsReloadPlugInsItem: false)
   private let viewUIModel = MainViewUIModel()

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

   required init?(coder: NSCoder) {
      fatalError("Please use this class from code.")
   }

   private func setupUI() {

      customWindow.autorecalculatesKeyViewLoop = false
      customWindow.minSize = CGSize(width: 320, height: 240)
      customWindow.title = "Window"
   }

   private func setupHandlers() {
      mainToolbar.eventHandler = { [weak self] in
         switch $0 {
         case .toggleMediaLibrary:
            self?.mlController.togglePanel(nil)
         case .reloadPlugIns:
            break
         }
      }
      viewUIModel.mediaLibraryLoader.eventHandler = { [weak self] in
         switch $0 {
         case .mediaSourceChanged:
            self?.mlController.isVisible = true
         }
      }
   }
}
