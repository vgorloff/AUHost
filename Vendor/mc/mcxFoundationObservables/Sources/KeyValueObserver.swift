//
//  KeyValueObserver.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation

/// - SeeAlso: https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual
/// BuildingCocoaApps/AdoptingCocoaDesignPatterns.html
/// ~~~
/// let observer = KeyValueObserver(object: mediaLibrary, keyPath: "mediaSources") { result in
///    // Do something
/// }
/// ~~~
public final class KeyValueObserver<ValueType: Any>: NSObject, Observable {

   public typealias ChangeCallback = (KeyValueObserverResult<ValueType>) -> Void

   private var context = 0 // Value don't reaaly matter. Only address is important.
   private var object: NSObject
   private var keyPath: String
   private var callback: ChangeCallback

   public var isSuspended = false // TODO: Maybe there is needed Thread-Safe implementation. By Vlad Gorlov, Jan 13, 2016.

   public init(object: NSObject, keyPath: String, options: NSKeyValueObservingOptions = .new,
               callback: @escaping ChangeCallback) {
      self.object = object
      self.keyPath = keyPath
      self.callback = callback
      super.init()
      object.addObserver(self, forKeyPath: keyPath, options: options, context: &context)
   }

   deinit {
      dispose()
   }

   public func dispose() {
      object.removeObserver(self, forKeyPath: keyPath, context: &context)
   }

   // MARK: -

   public static func observeNew<T>(object: NSObject, keyPath: String,
                                    callback: @escaping (T) -> Void) -> Observable {
      let observer = KeyValueObserver<T>(object: object, keyPath: keyPath, options: .new) { result in
         if let value = result.valueNew {
            callback(value)
         }
      }
      return observer
   }

   // MARK: -

   override public func observeValue(forKeyPath keyPath: String?, of object: Any?,
                                     change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
      if context == &self.context, keyPath == self.keyPath {
         if !isSuspended, let change = change, let result = KeyValueObserverResult<ValueType>(change: change) {
            callback(result)
         }
      } else {
         super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
      }
   }
}
