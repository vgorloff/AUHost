//
//  SpinLock.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 11.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

@available(iOS, deprecated: 10.0, message: "Use UnfairLock")
@available(OSX, deprecated: 10.12, message: "Use UnfairLock")
@available(tvOS, deprecated: 10.0, message: "Use UnfairLock")
@available(watchOS, deprecated: 3.0, message: "Use UnfairLock")
public final class SpinLock: NonRecursiveLocking {

   fileprivate var lock: OSSpinLock = OS_SPINLOCK_INIT

   public init() {
   }

   public func synchronized<T>(_ closure: () -> T) -> T {
      OSSpinLockLock(&lock)
      let result = closure()
      OSSpinLockUnlock(&lock)
      return result
   }

   public func synchronized<T>(_ closure: () throws -> T) throws -> T {
      OSSpinLockLock(&lock)
      do {
         let result = try closure()
         OSSpinLockUnlock(&lock)
         return result
      } catch {
         OSSpinLockUnlock(&lock)
         throw error
      }
   }
}
