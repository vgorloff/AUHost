//
//  AtomicPair.swift
//  mcBase-macOS
//
//  Created by Vlad Gorlov on 26.08.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import Foundation

public struct AtomicPair<T> {

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
   public mutating func swap(value: T) -> Bool {
      let nextIndex = index + 1
      let elementIndex = Int(nextIndex % 2)
      if values.count == 1 {
         values.append(value)
      } else {
         values[elementIndex] = value
      }
      let result = Atomic.compareAndSwap64Barrier(oldValue: index, newValue: nextIndex, theValue: &index)
      assert(result)
      return result
   }
}
