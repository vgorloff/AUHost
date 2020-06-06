//
//  FixedWidthInteger.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 25.08.19.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

extension FixedWidthInteger {

   public func subtractingIgnoringOverflow(_ rhs: Self) -> Self {
      let (partialValue, overflow) = subtractingReportingOverflow(rhs)
      if overflow {
         return 0
      } else {
         return partialValue
      }
   }
}
