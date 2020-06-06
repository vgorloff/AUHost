//
//  Int64Atomic.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//
public class Int64Atomic {

   private let instance: Int64AtomicOC

   public init(value: Int64) {
      instance = Int64AtomicOC(value: value)
   }

   public func load() -> Int64 {
      return instance.load()
   }

   public func compareExchangeStrong(withExpected: UnsafeMutablePointer<Int64>, desired: Int64) -> Bool {
      return instance.compareExchangeStrong(withExpected: withExpected, desired: desired)
   }
}
