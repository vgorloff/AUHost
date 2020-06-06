//
//  UniqueStringGenerator.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 01.12.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct UniqueStringGenerator {

   private var generator = UniqueNumberGenerator<Int64>()

   private let pefix: String
   private let suffix: String

   public init(pefix: String = "", suffix: String = "") {
      self.pefix = pefix
      self.suffix = suffix
   }

   public mutating func next() -> String {
      return pefix + "\(generator.next())" + suffix
   }
}
