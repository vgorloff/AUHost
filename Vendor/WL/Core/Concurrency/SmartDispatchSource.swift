//
//  SmartDispatchSource.swift
//  mcCore
//
//  Created by Volodymyr Gorlov on 08.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation

protocol _DispatchSourceType: class {
   var dispatchSource: DispatchSourceProtocol? { get set }
   // To prevent issue related to "BUG IN CLIENT OF LIBDISPATCH: Release of a suspended object"
   var dispatchSourceSuspendCount: Int { get set }
   func _resume()
   func _suspend()
   func _cancel()
   func _deinit()
}

extension _DispatchSourceType {
   func _resume() { // swiftlint:disable:this identifier_name
      guard let dispatchSourceInstance = dispatchSource else {
         return
      }
      if dispatchSourceSuspendCount > 0 {
         dispatchSourceInstance.resume()
         dispatchSourceSuspendCount -= 1
      }
   }

   func _suspend() { // swiftlint:disable:this identifier_name
      guard let dispatchSourceInstance = dispatchSource else {
         return
      }
      dispatchSourceInstance.suspend()
      dispatchSourceSuspendCount += 1
   }

   func _cancel() { // swiftlint:disable:this identifier_name
      guard let dispatchSourceInstance = dispatchSource else {
         return
      }
      if !dispatchSourceInstance.isCancelled {
         dispatchSourceInstance.cancel()
      }
   }

   func _deinit() { // swiftlint:disable:this identifier_name
      guard let dispatchSourceInstance = dispatchSource else {
         return
      }
      dispatchSourceInstance.setEventHandler(handler: nil)
      // To prevent issue related to "BUG IN CLIENT OF LIBDISPATCH: Release of a suspended object"
      while dispatchSourceSuspendCount > 0 {
         _resume()
      }
      _cancel()
      dispatchSource = nil
   }
}

public class SmartDispatchSource: _DispatchSourceType, SmartDispatchSourceType, CustomReflectable {

   var dispatchSource: DispatchSourceProtocol?
   var dispatchSourceSuspendCount = 1

   public func setEventHandler(qos: DispatchQoS = .default, flags: DispatchWorkItemFlags = .inheritQoS, handler: (() -> Void)?) {
      dispatchSource?.setEventHandler(qos: qos, flags: flags, handler: handler)
   }

   public func resume() {
      _resume()
   }

   public func suspend() {
      _suspend()
   }

   deinit {
      _deinit()
   }

   public var customMirror: Mirror {
      let children = DictionaryLiteral<String, Any>(dictionaryLiteral: ("dispatchSourceSuspendCount", dispatchSourceSuspendCount))
      return Mirror(self, children: children)
   }
}
