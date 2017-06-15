//
//  MainModel.swift
//  AUHost
//
//  Created by VG (DE) on 15.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import AVFoundation

class MainModel {

   enum Event {
      case audioComponentChanged(AudioComponentsUtility.StateChange)
   }

   var eventHandler: ((Event) -> Void)?

   private var audioUnitDatasource = AudioComponentsUtility()

   init() {
      audioUnitDatasource.handlerStateChange = { [weak self] change in guard let s = self else { return }
         s.eventHandler?(.audioComponentChanged(change))
      }
   }

   func reloadEffects(completion: (([AVAudioUnitComponent]) -> Void)?) {
      audioUnitDatasource.updateEffectList {
         completion?($0)
      }
   }
   
}
