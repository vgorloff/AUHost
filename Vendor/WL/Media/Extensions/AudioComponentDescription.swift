//
//  AudioComponentDescription.swift
//  WaveLabs
//
//  Created by VG (DE) on 23.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import AVFoundation

public extension AudioComponentDescription {
   public init(type: OSType, subType: OSType, manufacturer: OSType = kAudioUnitManufacturer_Apple,
               flags: UInt32 = 0, flagsMask: UInt32 = 0) {
      self.init(componentType: type, componentSubType: subType, componentManufacturer: manufacturer,
                componentFlags: flags, componentFlagsMask: flagsMask)
   }
}
