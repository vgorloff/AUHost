//
//  EffectWindowUIModel.swift
//  AUHost
//
//  Created by VG (DE) on 17.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation

protocol EffectWindowUIModelType {
   func windowWillClose()
}

class EffectWindowUIModel {

   enum CoordinatorEvent {
      case windowWillClose
   }

   var coordinatorHandler: ((CoordinatorEvent) -> Void)?
}

extension EffectWindowUIModel: EffectWindowUIModelType {

   func windowWillClose() {
      coordinatorHandler?(.windowWillClose)
   }
}
