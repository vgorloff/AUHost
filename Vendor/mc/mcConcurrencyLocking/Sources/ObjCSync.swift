//
//  ObjCSync.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 26.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import ObjectiveC

public final class ObjCSync: NonRecursiveLocking {
   private var _lock = 0
   public init() {
   }

   public final func synchronized<T>(_ closure: () -> T) -> T {
      objc_sync_enter(_lock)
      let result = closure()
      objc_sync_exit(_lock)
      return result
   }
}
