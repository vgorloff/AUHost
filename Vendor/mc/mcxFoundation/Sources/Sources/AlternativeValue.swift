//
//  AlternativeValue.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 27.01.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct AlternativeValue<T> {

   public var value: T
   public var altValue: T

   public var currentValue: T {
      return isUsedAltValue ? altValue : value
   }

   public var isUsedAltValue: Bool = false

   public init(_ aValue: T, altValue anAltValue: T) {
      value = aValue
      altValue = anAltValue
   }
}
