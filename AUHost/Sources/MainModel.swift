//
//  MainModel.swift
//  AUHost
//
//  Created by VG (DE) on 15.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import AVFoundation

class MainModel {

   private var audioUnitDatasource = AudioComponentsUtility()

   func reloadEffects(completion: (([AVAudioUnitComponent]) -> Void)?) {
      audioUnitDatasource.updateEffectList { [weak self] effects in guard let s = self else { return }
         completion?(effects)
      }
   }
   
}
