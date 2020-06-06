//
//  UniqueNumberGenerator.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 01.12.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct UniqueNumberGenerator<T: Numeric> {

   private var value: T

   public init(initialValue: T = 0) {
      value = initialValue
   }

   public mutating func next() -> T {
      value += 1
      return value
   }
}
