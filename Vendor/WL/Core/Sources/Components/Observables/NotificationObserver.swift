//
//  NotificationObserver.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 29/04/16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

class NotificationObserver: NSObject {

   typealias Handler = ((Foundation.Notification) -> Void)

   private var notificationObserver: NSObjectProtocol!
   var notificationHandler: Handler?
   private(set) var notificationName: NSNotification.Name
   private var notificationObject: AnyObject?

   init(name: NSNotification.Name, object: AnyObject? = nil, queue: OperationQueue = .main, handler: Handler? = nil) {
      notificationName = name
      notificationObject = object
      notificationHandler = handler
      super.init()
      notificationObserver = NotificationCenter.default.addObserver(forName: name, object: object, queue: queue) { [weak self] in
         self?.handleNotification($0)
      }
   }

   deinit {
      notificationHandler = nil
      NotificationCenter.default.removeObserver(notificationObserver, name: notificationName, object: notificationObject)
   }

   /// Calls block which was passed as *usingBlock* parameter.
   /// Child classes may override to change default behaviour.
   /// - parameter notification: Notification to handle.
   func handleNotification(_ notification: Foundation.Notification) {
      notificationHandler?(notification)
   }
}
