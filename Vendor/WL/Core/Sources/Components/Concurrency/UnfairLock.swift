//
//  SpinLock.swift
//  WL
//
//  Created by Vlad Gorlov on 11.07.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation

@available(iOS 10.0, OSX 10.12, *)
public final class UnfairLock: NonRecursiveLocking {

   fileprivate var lock = os_unfair_lock()

   public init() {
   }

   public func synchronized<T>(_ closure: () -> T) -> T {
      os_unfair_lock_lock(&lock)
      let result = closure()
      os_unfair_lock_unlock(&lock)
      return result
   }
}
