//
//  Range.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 15.11.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

extension Range where Bound == String.Index {

   public func dump() -> String {
      let l = lowerBound.utf16Offset(in: "")
      let u = upperBound.utf16Offset(in: "")
      return "\(l)..<\(u) (Note: The bounds representes as in pure UTF-8 string.)"
   }

   public func dump(in string: String) -> String {
      let l = lowerBound.utf16Offset(in: string)
      let u = upperBound.utf16Offset(in: string)
      return "\(l)..<\(u)"
   }
}

extension Range where Bound: FixedWidthInteger {

   public func expanding(by value: Bound) -> Range {
      let newValue = lowerBound - value ..< upperBound + value
      return newValue
   }

   public func shifted(by value: Bound) -> Range {
      let newValue = lowerBound + value ..< upperBound + value
      return newValue
   }
}
