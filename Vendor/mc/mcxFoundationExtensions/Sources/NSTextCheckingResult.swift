//
//  NSTextCheckingResult.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension NSTextCheckingResult {

   public var allRanges: [NSRange] {
      var result: [NSRange] = []
      for index in 0 ..< numberOfRanges {
         result.append(range(at: index))
      }
      return result
   }
}
