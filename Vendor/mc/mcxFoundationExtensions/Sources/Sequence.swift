//
//  Sequence.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 28/06/2018.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

extension Sequence {

   // See: Split Array to Arrays by value Swift: https://stackoverflow.com/questions/38921864/split-array-to-arrays-by-value-swift
   public func groupIntoArrayBy<U: Equatable>(keyFunc: (Element) -> U) -> [(U, [Element])] {
      var tupArr: [(U, [Element])] = []
      for el in self {
         let key = keyFunc(el)
         if tupArr.last?.0 == key {
            tupArr[tupArr.endIndex - 1].1.append(el)
         } else {
            tupArr.append((key, [el]))
         }
      }
      return tupArr
   }

   // See: Split Array to Arrays by value Swift: https://stackoverflow.com/questions/38921864/split-array-to-arrays-by-value-swift
   public func groupIntoArrayBy<U: Equatable, Value: Any>(keyTransform: (Element) -> U,
                                                          valueTransform: (Element) -> Value) -> [(U, [Value])] {
      var tupArr: [(U, [Value])] = []
      for el in self {
         let value = valueTransform(el)
         let key = keyTransform(el)
         if tupArr.last?.0 == key {
            tupArr[tupArr.endIndex - 1].1.append(value)
         } else {
            tupArr.append((key, [value]))
         }
      }
      return tupArr
   }
}
