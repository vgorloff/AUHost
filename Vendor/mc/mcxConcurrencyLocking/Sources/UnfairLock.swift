//
//  UnfairLock.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 11.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

@available(iOS 10.0, OSX 10.12, watchOS 3.0, *)
public final class UnfairLock: NonRecursiveLocking {

   private var lock = os_unfair_lock()

   public init() {
   }

   public func synchronized<T>(_ closure: () -> T) -> T {
      os_unfair_lock_lock(&lock)
      let result = closure()
      os_unfair_lock_unlock(&lock)
      return result
   }

   public func synchronized<T>(_ closure: () throws -> T) throws -> T {
      os_unfair_lock_lock(&lock)
      do {
         let result = try closure()
         os_unfair_lock_unlock(&lock)
         return result
      } catch {
         os_unfair_lock_unlock(&lock)
         throw error
      }
   }
}
