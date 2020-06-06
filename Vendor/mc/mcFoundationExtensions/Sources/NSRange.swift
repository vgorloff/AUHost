//
//  NSRange.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 20.11.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

public typealias UTF16Range = NSRange

extension NSRange {

   public init(lowerBound: Int, upperBound: Int) {
      self.init(location: lowerBound, length: upperBound - lowerBound)
   }

   public init(length: Int) {
      self.init(location: 0, length: length)
   }

   public init(location: Int) {
      self.init(location: location, length: 0)
   }

   public var isEmpty: Bool {
      return length <= 0
   }
}
