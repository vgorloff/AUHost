//
//  MainWindowController.swift
//  AUHost
//
//  Created by Vlad Gorlov on 22.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

   private lazy var mediaLibraryController = g.configure(NSMediaLibraryBrowserController.shared) {
      $0.mediaLibraries = [NSMediaLibraryBrowserController.Library.audio]
   }

   override func awakeFromNib() {
      super.awakeFromNib()
      let mainToolbar = MainToolbar(identifier: "ua.com.wavelabs.AUHost:mainToolbar")
      mainToolbar.eventHandler = { [unowned self] in
         switch $0 {
         case .toggleMediaLibrary:
            self.mediaLibraryController.togglePanel(self)
         case .reloadPlugIns:
            self.mainController.reloadEffectsList()
         }
      }
      window?.toolbar = mainToolbar
   }

   private var mainController: ViewController {
      guard let c = contentViewController as? ViewController else {
         fatalError()
      }
      return c
   }

   override func windowDidLoad() {
      super.windowDidLoad()
      Application.sharedInstance.mediaLibraryLoader.loadMediaLibrary { [weak self] in
         self?.mediaLibraryController.isVisible = true
      }
   }

}
