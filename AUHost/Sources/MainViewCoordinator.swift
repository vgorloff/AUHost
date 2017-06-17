//
//  MainViewCoordinator.swift
//  AUHost
//
//  Created by VG (DE) on 16.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import AppKit

class MainViewCoordinator {
   
   let uiModel = MainViewUIModel()
   private let viewController: MainViewController
   private let segueOpenEffect = NSStoryboardSegue.Identifier("S:OpenEffectView")
   private var coordinator: EffectWindowCoordinator?

   init(viewController: MainViewController) {
      self.viewController = viewController
      viewController.uiModel = uiModel
      setupHandlers()
   }
}

extension MainViewCoordinator {

   private func setupHandlers() {
      uiModel.coordinatorHandler = { [weak self] in guard let this = self else { return }
         switch $0 {
         case .openEffectView(let vc):
            this.coordinator = EffectWindowCoordinator(effectViewController: vc)
            this.coordinator?.eventHandler = {
               switch $0 {
               case .windowWillClose:
                  self?.uiModel.effectWindowWillClose()
               }
            }
            this.viewController.performSegue(withIdentifier: this.segueOpenEffect, sender: nil)
         case .closeEffectView:
            this.coordinator?.windowController?.close()
            this.coordinator = nil
         case .prepare(let segue):
            if segue.identifier == this.segueOpenEffect, let wc = segue.destinationController as? EffectWindowController {
               this.coordinator?.windowController = wc
               self?.uiModel.effectWindowWillOpen()
            }
         }
      }
   }

}
