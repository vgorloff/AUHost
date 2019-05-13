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

   deinit {
      if let notificationObserver = notificationObserver {
         NotificationCenter.default.removeObserver(notificationObserver, name: notificationName, object: notificationObject)
      }
   }
}
