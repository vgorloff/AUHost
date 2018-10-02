//
//  Atomic.swift
//  mcBase-macOS
//
//  Created by Vlad Gorlov on 26.08.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import Foundation

public struct Atomic {

   public static func compareAndSwap64Barrier(oldValue: Int64, newValue: Int64, theValue: UnsafeMutablePointer<Int64>) -> Bool {
      return OSAtomicCompareAndSwap64Barrier(oldValue, newValue, theValue)
   }
}
