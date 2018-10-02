//
//  WriteSynchronizedProperty.swift
//  mcCore
//
//  Created by Vlad Gorlov on 11.07.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation

public final class WriteSynchronizedProperty<T>: CustomReflectable {

   private var valueStorage: T
   private let lock: NonRecursiveLocking

   /// Locks getter/setter using NSLock while reading/writing operations.
   public var value: T {
      get {
         return valueStorage
      } set {
         lock.synchronized {
            valueStorage = newValue
         }
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
