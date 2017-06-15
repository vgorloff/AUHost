//
//  MainViewModel.swift
//  AUHost
//
//  Created by VG (DE) on 15.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation
import AVFoundation

class MainViewModel {

   enum ViewEvent {
      case loadingEffects(Bool)
   }

   enum CoordinatorEvent {
      case noop
   }

   var viewHandler: ((ViewEvent) -> Void)?
   var coordinatorHandler: ((CoordinatorEvent) -> Void)?

   var model: MainModel?
   var availableEffects = [AVAudioUnitComponent]()

   func reloadEffects() {
      guard let model = model else {
         return
      }
      viewHandler?(.loadingEffects(true))
      model.reloadEffects { [weak self] in guard let s = self else { return }
         s.availableEffects = $0
         s.viewHandler?(.loadingEffects(false))
      }

   }
}
