//
//  EffectWindowController.swift
//  AUHost
//
//  Created by Vlad Gorlov on 16.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AppKit

protocol EffectWindowCoordination: class {
   func handleEvent(_: EffectWindowController.CoordinationEvent)
}

class EffectWindowController: NSWindowController {

   private lazy var customWindow = NSWindow(contentRect: CGRect(x: 1118, y: 286, width: 480, height: 270),
                                            styleMask: [.titled, .closable, .miniaturizable, .resizable, .nonactivatingPanel],
                                            backing: .buffered, defer: true)

   enum CoordinationEvent {
      case windowWillClose
   }

   weak var coordinationDelegate: EffectWindowCoordination?

   init() {
      super.init(window: nil)
      window = customWindow
      window?.delegate = self
      setupUI()
   }

   required init?(coder: NSCoder) {
      fatalError("Please use this class from code.")
   }

   private func setupUI() {

      customWindow.autorecalculatesKeyViewLoop = false
      customWindow.title = "Window"

      windowFrameAutosaveName = NSWindow.FrameAutosaveName(string(fromClass: EffectWindowController.self) + ":WindowFrame")
   }

   override func awakeFromNib() {
      super.awakeFromNib()
   }

   deinit {
      log.deinitialize()
   }
}

extension EffectWindowController: NSWindowDelegate {

   func windowWillClose(_: Notification) {
      coordinationDelegate?.handleEvent(.windowWillClose)
   }
}
