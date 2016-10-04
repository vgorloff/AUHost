//
//  MainWindowController.swift
//  AUHost
//
//  Created by Vlad Gorlov on 22.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

   private lazy var mediaLibraryController = g.configure(NSMediaLibraryBrowserController.shared()) {
      $0.mediaLibraries = [NSMediaLibrary.audio]
   }

   private var mainController: ViewController {
      guard let c = contentViewController as? ViewController else {
         fatalError()
      }
      return c
   }

   override func windowDidLoad() {
      super.windowDidLoad()
      NSApplication.shared().applicationDelegate.mediaLibraryLoader.loadMediaLibrary { [weak self] in
         self?.mediaLibraryController.isVisible = true
      }
   }

   @IBAction private func actionToggleMediaLibraryBrowser(_ sender: AnyObject?) {
      mediaLibraryController.togglePanel(sender)
   }

   @IBAction private func actionReloadPlugIns(_ sender: AnyObject?) {
      mainController.reloadEffectsList()
   }
}
