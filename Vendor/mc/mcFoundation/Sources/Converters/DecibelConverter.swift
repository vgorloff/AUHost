//
//  DecibelConverter.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 13.03.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct DecibelConverter {

   public static func absoluteValue(dbValue: Double) -> Double {
      return pow(10, dbValue / Double(20))
   }

   public static func dbValue(absoluteValue: Double, minValue: Double = -120) -> Double {
      guard absoluteValue >= 0 else {
         return minValue
      }
      return 20.0 * log10(absoluteValue)
   }
}
