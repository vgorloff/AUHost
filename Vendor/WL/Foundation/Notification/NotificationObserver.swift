//
//  NotificationObserver.swift
//  mcCore
//
//  Created by Vlad Gorlov on 29/04/16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

public class NotificationObserver: NSObject {

   public typealias Handler = ((Foundation.Notification) -> Void)

   private var notificationObserver: NSObjectProtocol!
   public var handler: Handler?
   public private(set) var notificationName: NSNotification.Name
   private let notificationObject: Any?

   public init(name: NSNotification.Name, object: Any? = nil, queue: OperationQueue = .main, handler: Handler? = nil) {
      notificationName = name
      notificationObject = object
      self.handler = handler
      super.init()
      notificationObserver = NotificationCenter.default.addObserver(forName: name, object: object, queue: queue) { [weak self] in
         self?.handler?($0)
      }
   }

   deinit {
      NotificationCenter.default.removeObserver(notificationObserver, name: notificationName, object: notificationObject)
   }
}
