//
//  NonRecursiveLock.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 10/08/16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Darwin

public struct NonRecursiveLock {

   public static func makeDefaultLock() -> NonRecursiveLocking {
      if #available(iOS 10.0, OSX 10.12, *) {
         return UnfairLock()
      } else {
         return SpinLock()
      }
   }
}
