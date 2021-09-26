//
//  IntAtomic.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//
public class IntAtomic {

   private let instance: IntAtomicOC

   public init(value: Int) {
      instance = IntAtomicOC(value: value)
   }

   public func load() -> Int {
      return instance.load()
   }

   public func compareExchangeStrong(withExpected: UnsafeMutablePointer<Int>, desired: Int) -> Bool {
      return instance.compareExchangeStrong(withExpected: withExpected, desired: desired)
   }
}
