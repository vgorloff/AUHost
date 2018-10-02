//
//  Property.swift
//  mcCore
//
//  Created by Vlad Gorlov on 11.07.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation

/// Provides atomic access to Property.value from different threads.
public final class Property<T>: CustomReflectable {

   private var valueStorage: T
   private let lock: NonRecursiveLocking

   /// Locks getter/setter using NSLock while reading/writing operations.
   public var value: T {
      get {
         return lock.synchronized {
            valueStorage
         }
      } set {
         lock.synchronized {
            valueStorage = newValue
         }
      }
   }

   public func synchronized(closure: (inout T) -> Void) {
      _ = lock.synchronized {
         closure(&valueStorage)
      }
   }

   public init(_ initialValue: T, lock: NonRecursiveLocking = NonRecursiveLock.makeDefaultLock()) {
      valueStorage = initialValue
      self.lock = lock
   }

   public var customMirror: Mirror {
      let children = DictionaryLiteral<String, Any>(dictionaryLiteral: ("value", valueStorage), ("lock", lock))
      return Mirror(self, children: children)
   }
}

public func <- <T>(left: Property<T>, right: T) {
   left.value = right
}

public postfix func ^ <T>(left: Property<T>) -> T {
   return left.value
}
