//
//  ValueObserver.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 10/08/16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct ValueObserverResult<T: Any> {

   public fileprivate(set) var change: [NSKeyValueChangeKey: Any]
   public fileprivate(set) var kind: NSKeyValueChange

   public var valueNew: T? {
      return change[NSKeyValueChangeKey.newKey] as? T
   }

   public var valueOld: T? {
      return change[NSKeyValueChangeKey.oldKey] as? T
   }

   var isPrior: Bool {
      return (change[NSKeyValueChangeKey.notificationIsPriorKey] as? NSNumber)?.boolValue ?? false
   }

   var indexes: IndexSet? {
      return change[NSKeyValueChangeKey.indexesKey] as? IndexSet
   }

   init?(change: [NSKeyValueChangeKey: Any]) {
      self.change = change
      guard
         let changeKind = change[NSKeyValueChangeKey.kindKey] as? NSNumber,
         let kind = NSKeyValueChange(rawValue: changeKind.uintValue) else {
         return nil
      }
      self.kind = kind
   }
}

/// ~~~
/// let observer = ValueObserver(object: myObject, keyPath: #keyPath(myObject.property)) { result in
///    // Do something
/// }
/// ~~~
public final class ValueObserver<T: Any>: NSObject {

   public typealias ValueChangeHandler = (ValueObserverResult<T>) -> Void

   fileprivate var context = 0
   fileprivate var object: NSObject
   fileprivate var keyPath: String
   fileprivate var options: NSKeyValueObservingOptions
   public var changeHandler: ValueChangeHandler?

   public var suspended = false // TODO: Maybe there is needed Thread-Safe implementation. By Vlad Gorlov, Jan 13, 2016.

   public init(object: NSObject, keyPath: String, options: NSKeyValueObservingOptions = .new,
               changeHandler: ValueChangeHandler? = nil) {
      self.object = object
      self.keyPath = keyPath
      self.options = options
      self.changeHandler = changeHandler
      super.init()
      object.addObserver(self, forKeyPath: keyPath, options: options, context: &context)
   }

   deinit {
      object.removeObserver(self, forKeyPath: keyPath, context: &context)
   }

   override public func observeValue(forKeyPath aKeyPath: String?, of object: Any?,
                                     change aChange: [NSKeyValueChangeKey: Any]?,
                                     context aContext: UnsafeMutableRawPointer?) {
      if aContext == &context, aKeyPath == keyPath {
         if !suspended, let change = aChange, let result = ValueObserverResult<T>(change: change) {
            changeHandler?(result)
         }
      } else {
         super.observeValue(forKeyPath: keyPath, of: object, change: aChange, context: aContext)
      }
   }
}
