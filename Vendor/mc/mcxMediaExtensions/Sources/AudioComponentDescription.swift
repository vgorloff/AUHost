//
//  AudioComponentDescription.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.06.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import AVFoundation

extension AudioComponentDescription {
   public init(type: OSType, subType: OSType, manufacturer: OSType = kAudioUnitManufacturer_Apple,
               flags: UInt32 = 0, flagsMask: UInt32 = 0) {
      self.init(componentType: type, componentSubType: subType, componentManufacturer: manufacturer,
                componentFlags: flags, componentFlagsMask: flagsMask)
   }
}

extension AudioComponentDescription: Equatable {

   public static func == (lhs: AudioComponentDescription, rhs: AudioComponentDescription) -> Bool {
      return lhs.componentFlags == rhs.componentFlags && lhs.componentFlagsMask == rhs.componentFlagsMask && lhs.componentManufacturer == rhs.componentManufacturer && lhs.componentSubType == rhs.componentSubType && lhs.componentType == rhs.componentType
   }
}
