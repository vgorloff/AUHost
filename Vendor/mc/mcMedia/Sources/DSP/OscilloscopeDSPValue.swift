//
//  OscilloscopeDSPValue.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 21.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

// Value should be always in range -1...1
public struct OscilloscopeDSPValue<T: BinaryFloatingPoint> {

   public let min: T
   public let max: T
   public let average: T

   init(value: T) {
      min = value
      max = value
      average = min + ((max - min) / 2)
   }

   init(min: T, max: T) {
      self.min = min
      self.max = max
      average = min + ((max - min) / 2)
   }

   public init() {
      min = 0
      max = 0
      average = 0
   }

   public init(min: T, max: T, average: T) {
      self.min = min
      self.max = max
      self.average = average
   }
}

extension OscilloscopeDSPValue: DefaultInitializerType {
}
