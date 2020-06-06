//
//  NonRecursiveMutex.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 11.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

/// Wrapper class for locking block of code. Uses non-recursive pthread_mutex_t for locking.
/// ~~~
/// let s = NonRecursiveMutex()
/// let value = s.synchronized {
///     return "XYZ"
/// }
/// ~~~
public final class NonRecursiveMutex: NonRecursiveLocking {
   private let _mutex: UnsafeMutablePointer<pthread_mutex_t>
   public init() {
      _mutex = UnsafeMutablePointer.allocate(capacity: 1)
      pthread_mutex_init(_mutex, nil)
   }

   public final func synchronized<T>(_ closure: () -> T) -> T {
      pthread_mutex_lock(_mutex)
      let result = closure()
      pthread_mutex_unlock(_mutex)
      return result
   }

   deinit {
      pthread_mutex_destroy(_mutex)
      _mutex.deallocate()
   }
}
