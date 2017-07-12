//
//  MainWindowController.swift
//  Attenuator
//
//  Created by Vlad Gorlov on 06/10/2016.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

   private lazy var mlController: NSMediaLibraryBrowserController = Util.configure(NSMediaLibraryBrowserController.shared) {
      $0.mediaLibraries = [NSMediaLibraryBrowserController.Library.audio]
   }
   let mainToolbarID = NSToolbar.Identifier("ua.com.wavelabs.Attenuator:mainToolbar")
   lazy var mainToolbar: MainToolbar = MainToolbar(identifier: self.mainToolbarID, showsReloadPlugInsItem: false)
   private let viewUIModel = MainViewUIModel()

   override func windowDidLoad() {
      super.windowDidLoad()
      guard let vc = contentViewController as? ViewController else {
         fatalError("Wrong type for initial view controller. Expected `\(ViewController.self)`")
      }
      vc.uiModel = viewUIModel
      viewUIModel.mediaLibraryLoader.loadMediaLibrary { [weak self] in
         self?.mlController.isVisible = true
      }
      window?.toolbar = mainToolbar
      mainToolbar.eventHandler = { [unowned self] in
         switch $0 {
         case .toggleMediaLibrary:
            self.mlController.togglePanel(self)
         case .reloadPlugIns:
            break
         }
      }
   }

}
