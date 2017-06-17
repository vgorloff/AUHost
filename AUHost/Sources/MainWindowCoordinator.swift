//
//  MainWindowCoordinator.swift
//  AUHost
//
//  Created by VG (DE) on 17.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import AppKit

class MainWindowCoordinator {

   private var viewCoordinator: MainViewCoordinator!
   private let uiModel = MainWindowUIModel()
   private var windowController: MainWindowController!
   private lazy var mlController = g.configure(NSMediaLibraryBrowserController.shared) {
      $0.mediaLibraries = [NSMediaLibraryBrowserController.Library.audio]
   }

   init() {
      setupHandlers()
      guard let wc = AppConfig.mainWindowController as? MainWindowController else {
         fatalError("Wrong type for initial window controller. Expected `\(MainWindowController.self)`")
      }
      guard let vc = wc.contentViewController as? MainViewController else {
         fatalError("Wrong type for initial view controller. Expected `\(MainViewController.self)`")
      }
      windowController = wc
      windowController.uiModel = uiModel
      viewCoordinator = MainViewCoordinator(viewController: vc)
      viewCoordinator.uiModel.mediaLibraryLoader.loadMediaLibrary { [weak self] in
         self?.mlController.isVisible = true
      }
   }

   func start() -> NSWindowController {
      return windowController
   }
   
}

extension MainWindowCoordinator {

   func setupHandlers() {
      uiModel.coordinatorHandler = { [unowned self] in
         switch $0 {
         case .reloadEffects:
            self.viewCoordinator.uiModel.reloadEffects()
         case .toggleMediaBrowser(let sender):
            self.mlController.togglePanel(sender)
         }
      }

   }
}
