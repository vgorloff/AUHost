//
//  Int.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 02.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

extension Int {

   public static func kilobytes(_ bytes: Int) -> Int {
      return bytes * 1000
   }

   public static func megabytes(_ bytes: Int) -> Int {
      return .kilobytes(bytes) * 1000
   }

   public static func gigabytes(_ bytes: Int) -> Int {
      return .megabytes(bytes) * 1000
   }

   public func compare(_ other: Int) -> ComparisonResult {
      if self > other {
         return .orderedDescending
      } else if self < other {
         return .orderedAscending
      } else {
         return .orderedSame
      }
   }
}
