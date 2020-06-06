//
//  AtomicPair.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 26.08.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

public class AtomicPair<T> {

   private var atomic = Int64AtomicOC(value: 0)

   private var values: [T] = []

   private var index: Int64 = 0

   public var value: T {
      if values.count == 1 {
         return values[0]
      } else {
         return index % 2 == 0 ? values[0] : values[1]
      }
   }

   public init(value: T) {
      values.append(value)
   }

   @discardableResult
   public func swap(value: T) -> Bool {
      let nextIndex = index + 1
      let elementIndex = Int(nextIndex % 2)
      if values.count == 1 {
         values.append(value)
      } else {
         values[elementIndex] = value
      }
      // FIXME: Use loops. See examples in `Atomic.h` from `ObjC` submodule.
      let result = atomic.compareExchangeStrong(withExpected: &index, desired: nextIndex)
      if result {
         index = atomic.load()
      }
      assert(result)
      return result
   }
}
