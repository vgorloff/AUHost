//
//  FoundationUtilities.swift
//  WaveLabs
//
//  Created by Volodymyr Gorlov on 01.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

extension Notification {

   public class SmartObserver {

      public typealias HandleNotificationBlock = ((Notification) -> Void)
      private var notificationObserver: NSObjectProtocol!
      private var notificationCallbackBlock: HandleNotificationBlock?

      public init(forName name: Notification.Name, object: AnyObject? = nil,
                  queue: OperationQueue = OperationQueue.main, usingBlock: HandleNotificationBlock? = nil) {
         notificationCallbackBlock = usingBlock
         notificationObserver = NotificationCenter.default.addObserver(
         forName: name, object: object, queue: queue) { [weak self] in
            self?.handleNotification($0)
         }
      }

      deinit {
         notificationCallbackBlock = nil
         NotificationCenter.default.removeObserver(notificationObserver)
      }

      /// Calls block which was passed as *usingBlock* parameter.
      /// Child classes may override to change default behaviour.
      /// - parameter notification: Notification to handle.
      public func handleNotification(_ notification: Notification) {
         if let callbackBlock = notificationCallbackBlock {
            callbackBlock(notification)
         }
      }

   }

}
