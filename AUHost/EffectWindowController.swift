//
//  EffectWindowController.swift
//  AUHost
//
//  Created by Vlad Gorlov on 16.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AppKit

class EffectWindowController: NSWindowController, NSWindowDelegate {

   var handlerWindowWillClose: (() -> Void)?

   override func awakeFromNib() {
      super.awakeFromNib()
      windowFrameAutosaveName = g.string(fromClass: EffectWindowController.self) + ":WindowFrame"
   }

   // MARK: - NSWindowDelegate

   func windowWillClose(_ notification: Notification) {
      handlerWindowWillClose?()
   }
}
