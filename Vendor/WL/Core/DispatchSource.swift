//
//  DispatchSource.swift
//  WaveLabs
//
//  Created by Volodymyr Gorlov on 08.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation

private protocol _SmartDispatchSourceType: class {
   var dispatchSource: DispatchSourceProtocol? { get set }
   // To prevent issue related to "BUG IN CLIENT OF LIBDISPATCH: Release of a suspended object"
   var dispatchSourceSuspendCount: Int { get set }
   func _resume()
   func _suspend()
   func _cancel()
   func _deinit()
}

extension _SmartDispatchSourceType {
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
      if dispatchSourceInstance.isCancelled {
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

public protocol SmartDispatchSourceType: class {
   func resume()
   func suspend()
   func setEventHandler(qos: DispatchQoS, flags: DispatchWorkItemFlags, handler: (() -> Void)?)
}

public class SmartDispatchSource: _SmartDispatchSourceType, SmartDispatchSourceType, CustomReflectable {

   fileprivate var dispatchSource: DispatchSourceProtocol?
   fileprivate var dispatchSourceSuspendCount = 1

   public func setEventHandler(qos: DispatchQoS = .default, flags: DispatchWorkItemFlags = .inheritQoS,
                               handler: (() -> Void)?) {
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

public final class SmartDispatchSourceTimer: SmartDispatchSource {

   public init(flags: DispatchSource.TimerFlags = [], queue: DispatchQueue? = nil) {
      super.init()
      dispatchSource = DispatchSource.makeTimerSource(flags: flags, queue: queue)
   }

   public func scheduleRepeating(deadline: DispatchTime, interval: DispatchTimeInterval,
                                 leeway: DispatchTimeInterval = .milliseconds(0)) {
      if let timer = dispatchSource as? DispatchSourceTimer {
         timer.scheduleRepeating(deadline: deadline, interval: interval, leeway: leeway)
      }
   }
}

public final class SmartDispatchSourceUserDataAdd: SmartDispatchSource {
   public init(queue: DispatchQueue? = nil) {
      super.init()
      dispatchSource = DispatchSource.makeUserDataAddSource(queue: queue)
   }

   public func mergeData(value: UInt) {
      guard let dispatchSourceInstance = dispatchSource as? DispatchSourceUserDataAdd else {
         return
      }
      dispatchSourceInstance.add(data: value)
   }
}

public final class SmartDispatchSourceUserDataOr: SmartDispatchSource {
   public init(queue: DispatchQueue? = nil) {
      super.init()
      dispatchSource = DispatchSource.makeUserDataOrSource(queue: queue)
   }

   public func mergeData(value: UInt) {
      guard let dispatchSourceInstance = dispatchSource as? DispatchSourceUserDataOr else {
         return
      }
      dispatchSourceInstance.or(data: value)
   }
}
