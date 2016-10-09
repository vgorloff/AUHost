//
//  MainWindowController.swift
//  Attenuator
//
//  Created by Vlad Gorlov on 06/10/2016.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

   private lazy var mediaLibraryController = g.configure(NSMediaLibraryBrowserController.shared()) {
      $0.mediaLibraries = [NSMediaLibrary.audio]
   }

   override func awakeFromNib() {
      super.awakeFromNib()
      let mainToolbar = MainToolbar(identifier: "ua.com.wavelabs.Attenuator:mainToolbar", showsReloadPlugInsItem: false)
      mainToolbar.eventHandler = { [unowned self] in
         switch $0 {
         case .toggleMediaLibrary:
            self.mediaLibraryController.togglePanel(self)
         case .reloadPlugIns:
            break
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
