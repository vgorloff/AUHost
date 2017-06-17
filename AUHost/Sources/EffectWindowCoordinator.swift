//
//  EffectWindowCoordinator.swift
//  AUHost
//
//  Created by VG (DE) on 17.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import AppKit

class EffectWindowCoordinator {

   enum Event {
      case windowWillClose
   }

   var eventHandler: ((Event) -> Void)?

   private let uiModel = EffectWindowUIModel()
   private let effectViewController: NSViewController
   var windowController: EffectWindowController? {
      didSet {
         windowController?.uiModel = uiModel
         windowController?.contentViewController = effectViewController
      }
   }

   init(effectViewController: NSViewController) {
      self.effectViewController = effectViewController
      uiModel.coordinatorHandler = { [weak self] in
         switch $0 {
         case .windowWillClose:
            self?.eventHandler?(.windowWillClose)
         }
      }
   }

   deinit {
      windowController?.contentViewController = nil
   }
}
