//
//  DispatchQueue.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public extension DispatchQueue {

   public static var Default: DispatchQueue {
      return DispatchQueue.global(qos: .default)
   }

   public static var UserInteractive: DispatchQueue {
      return DispatchQueue.global(qos: .userInteractive)
   }

   public static var UserInitiated: DispatchQueue {
      return DispatchQueue.global(qos: .userInitiated)
   }

   public static var Utility: DispatchQueue {
      return DispatchQueue.global(qos: .utility)
   }

   public static var Background: DispatchQueue {
      return DispatchQueue.global(qos: .background)
   }

   public static func serial(label: String) -> DispatchQueue {
      return DispatchQueue(label: label)
   }

   public func smartSync<T>(execute work: () throws -> T) rethrows -> T {
      if Thread.isMainThread {
         return try work()
      } else {
         return try sync(execute: work)
      }
   }
}
