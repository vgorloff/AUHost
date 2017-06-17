//
//  MainWindowController.swift
//  AUHost
//
//  Created by Vlad Gorlov on 22.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

   var uiModel: MainWindowUIModelType?

   private let mainToolbar = MainToolbar(identifier: NSToolbar.Identifier("ua.com.wavelabs.AUHost:mainToolbar"))

   override func windowDidLoad() {
      super.windowDidLoad()
      window?.toolbar = mainToolbar
      setupHandlers()
   }

}

extension MainWindowController {

   private func setupHandlers() {
      mainToolbar.eventHandler = { [unowned self] in
         switch $0 {
         case .toggleMediaLibrary:
            self.uiModel?.toggleMediaBrowser(sender: self)
         case .reloadPlugIns:
            self.uiModel?.reloadEffects()
         }
      }
   }

}
