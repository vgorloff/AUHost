//
//  NSLocker.swift
//  mcCore
//
//  Created by Vlad Gorlov on 11.07.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation

public final class NSLocker: NonRecursiveLocking {
   private let lock = NSLock()
   public init() {
   }

   public final func synchronized<T>(_ closure: () -> T) -> T {
      lock.lock()
      let result = closure()
      lock.unlock()
      return result
   }
}
