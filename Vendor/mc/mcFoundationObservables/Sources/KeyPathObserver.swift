//
//  KeyPathObserver.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 30.05.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

public class KeyPathObserver<ObjectType: NSObject, ValueType>: Observable {

   public typealias ChangeHandler = (ObjectType, NSKeyValueObservedChange<ValueType>) -> Void
   public var isSuspended: Bool = false

   private var observer: NSKeyValueObservation!
   private let changeHandler: ChangeHandler

   public init(object: ObjectType,
               keyPath: KeyPath<ObjectType, ValueType>,
               options: NSKeyValueObservingOptions,
               changeHandler: @escaping ChangeHandler) {
      self.changeHandler = changeHandler
      observer = object.observe(keyPath, options: options) { [weak self] object, change in guard let this = self else { return }
         if !this.isSuspended {
            this.changeHandler(object, change)
         }
      }
   }

   deinit {
      dispose()
   }

   public func dispose() {
      observer.invalidate()
   }

   public func suspend() {
      isSuspended = true
   }

   public func resume() {
      isSuspended = false
   }

   public static func observeNew(object: ObjectType,
                                 keyPath: KeyPath<ObjectType, ValueType>,
                                 changeHandler: @escaping (ObjectType, ValueType) -> Void) -> Observable {
      let observer = KeyPathObserver(object: object, keyPath: keyPath, options: .new) { object, change in
         if let newValue = change.newValue {
            changeHandler(object, newValue)
         }
      }
      return observer
   }
}
