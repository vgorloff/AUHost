//
//  GenericNotification.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 07.04.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

private let genericNotificationPayloadKey = "com.mc.notification-payload"

public class GenericNotification<T: Any> {

   let payload: T
   let name: NSNotification.Name
   let object: Any?

   public init(name: NSNotification.Name, object: Any? = nil, payload: T) {
      self.name = name
      self.object = object
      self.payload = payload
   }

   public init?(notification: Notification) {
      guard let payload = notification.userInfo?[genericNotificationPayloadKey] as? T else {
         return nil
      }
      self.payload = payload
      name = notification.name
      object = notification.object
   }
}

extension GenericNotification {

   var notification: Notification {
      return Notification(name: name, object: object, userInfo: [genericNotificationPayloadKey: payload])
   }

   public static func observe(name: NSNotification.Name,
                              object: Any? = nil,
                              queue: OperationQueue = .main,
                              handler: @escaping (T) -> Void) -> NotificationObserver {
      return NotificationObserver(name: name, object: object, queue: queue) {
         if let notification = GenericNotification(notification: $0) {
            handler(notification.payload)
         }
      }
   }

   public func post(center: NotificationCenter = NotificationCenter.default) {
      center.post(notification)
   }
}
