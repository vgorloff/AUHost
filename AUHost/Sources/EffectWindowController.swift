//
//  EffectWindowController.swift
//  AUHost
//
//  Created by Vlad Gorlov on 16.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AppKit

class EffectWindowController: NSWindowController {

   var uiModel: EffectWindowUIModelType?

   override func awakeFromNib() {
      super.awakeFromNib()
      windowFrameAutosaveName = NSWindow.FrameAutosaveName(g.string(fromClass: EffectWindowController.self) + ":WindowFrame")
   }

   deinit {
      Logger.deinitialize(subsystem: .controller)
   }
}

extension EffectWindowController: NSWindowDelegate {

   func windowWillClose(_ notification: Notification) {
      uiModel?.windowWillClose()
   }
}
