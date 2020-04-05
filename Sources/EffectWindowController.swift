//
//  EffectWindowController.swift
//  AUHost
//
//  Created by Vlad Gorlov on 16.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AppKit
import mcFoundation

class EffectWindowController: NSWindowController {

   enum Event {
      case windowWillClose
   }

   var eventHandler: ((Event) -> Void)?

   private lazy var customWindow = NSWindow(contentRect: CGRect(x: 1118, y: 286, width: 480, height: 270),
                                            styleMask: [.titled, .closable, .miniaturizable, .resizable, .nonactivatingPanel],
                                            backing: .buffered, defer: true)

   init() {
      super.init(window: nil)
      window = customWindow
      window?.delegate = self
      setupUI()
   }

   required init?(coder: NSCoder) {
      fatalError("Please use this class from code.")
   }

   deinit {
      log.deinitialize()
   }
}

extension EffectWindowController: NSWindowDelegate {

   func windowWillClose(_: Notification) {
      eventHandler?(.windowWillClose)
   }
}

extension EffectWindowController {

   private func setupUI() {
      windowFrameAutosaveName = NSWindow.FrameAutosaveName(string(fromClass: EffectWindowController.self) + ":WindowFrame")
   }
}
