//
//  NotificationObserver.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 29/04/16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

open class NotificationObserver: NSObject {

   public typealias Handler = ((Foundation.Notification) -> Void)

   private var notificationObserver: NSObjectProtocol!
   private let notificationObject: Any?

   public var handler: Handler?
   public var isActive: Bool = true
   public private(set) var notificationName: NSNotification.Name

   public init(name: NSNotification.Name, object: Any? = nil, queue: OperationQueue = .main, handler: Handler? = nil) {
      notificationName = name
      notificationObject = object
      self.handler = handler
      super.init()
      notificationObserver = NotificationCenter.default.addObserver(forName: name, object: object, queue: queue) { [weak self] in
         guard let this = self else { return }
         if this.isActive {
            self?.handler?($0)
         }
      }
   }

   public func setHandler<T: AnyObject>(_ caller: T, _ workItem: @escaping (T, Foundation.Notification) -> Void) {
      handler = { [weak caller] event in guard let strongCaller = caller else { return }
         workItem(strongCaller, event)
      }
   }

   deinit {
      if let notificationObserver = notificationObserver {
         NotificationCenter.default.removeObserver(notificationObserver, name: notificationName, object: notificationObject)
      }
   }
}

extension Array where Element == NotificationObserver {

   public struct NotificationObservers {

      private let instance: [NotificationObserver]

      fileprivate init(instance: [NotificationObserver]) {
         self.instance = instance
      }

      public func suspend() {
         instance.forEach { $0.isActive = false }
      }

      public func resume() {
         instance.forEach { $0.isActive = true }
      }
   }

   public var asObservables: NotificationObservers {
      return NotificationObservers(instance: self)
   }
}
