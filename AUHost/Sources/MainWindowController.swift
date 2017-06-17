//
//  MainWindowController.swift
//  AUHost
//
//  Created by Vlad Gorlov on 22.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

   private let viewUIModel = MainViewUIModel()
   private let mainToolbar = MainToolbar(identifier: NSToolbar.Identifier("ua.com.wavelabs.AUHost:mainToolbar"))
   private lazy var mlController = g.configure(NSMediaLibraryBrowserController.shared) {
      $0.mediaLibraries = [NSMediaLibraryBrowserController.Library.audio]
   }

   override func windowDidLoad() {
      super.windowDidLoad()
      window?.toolbar = mainToolbar
      setupHandlers()
      guard let vc = contentViewController as? MainViewController else {
         fatalError("Wrong type for initial view controller. Expected `\(MainViewController.self)`")
      }
      vc.uiModel = viewUIModel
      viewUIModel.mediaLibraryLoader.loadMediaLibrary { [weak self] in
         self?.mlController.isVisible = true
      }
   }

}

extension MainWindowController {

   private func setupHandlers() {
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
