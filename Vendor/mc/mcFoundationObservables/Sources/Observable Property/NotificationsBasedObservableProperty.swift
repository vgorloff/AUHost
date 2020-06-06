//
//  NotificationsBasedObservableProperty.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 28.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcRuntime

class DisposableNotificationSubscription: Disposable {

   private var notificationCenter: NotificationCenter?
   private var token: NSObjectProtocol?

   init(notificationCenter: NotificationCenter, token: NSObjectProtocol) {
      self.notificationCenter = notificationCenter
      self.token = token
   }

   deinit {
      dispose()
   }

   var isDisposed: Bool {
      return token == nil
   }

   func dispose() {
      if let token = token, let notificationCenter = notificationCenter {
         notificationCenter.removeObserver(token)
         self.token = nil
         self.notificationCenter = nil
      }
   }
}

public class NotificationsBasedObservableProperty<T> {

   public var value: T {
      didSet {
         notificationCenter.post(name: notificationName, object: value)
      }
   }

   public init(_ value: T) {
      self.value = value
   }

   deinit {
      removeAllObservers()
   }

   private var observables: [DisposableNotificationSubscription] = []
   private let notificationCenter = NotificationCenter()
   private let notificationName = Notification.Name(rawValue: "app.notificaion.didSet")

   public func addObserver(fireWithInitialValue: Bool = true, on queue: DispatchQueue? = nil,
                           _ observer: @escaping (T) -> Void) -> Disposable {
      var opQueue: OperationQueue?
      if let queue = queue {
         if queue == DispatchQueue.main {
            opQueue = OperationQueue.main
         } else {
            let q = OperationQueue()
            q.underlyingQueue = queue
            opQueue = q
         }
      }
      let token = notificationCenter.addObserver(forName: notificationName, object: nil, queue: opQueue) { notification in
         if let object = notification.object as? T {
            observer(object)
         } else {
            Assertion.shouldNeverHappen()
         }
      }
      if fireWithInitialValue {
         if let queue = queue {
            queue.async { observer(self.value) }
         } else {
            observer(value)
         }
      }
      let disposable = DisposableNotificationSubscription(notificationCenter: notificationCenter, token: token)
      observables.append(disposable)
      return disposable
   }

   public func addObserver<CallerType: AnyObject>(_ caller: CallerType,
                                                  fireWithInitialValue: Bool = true,
                                                  on queue: DispatchQueue? = nil,
                                                  _ observer: @escaping (CallerType, T) -> Void) -> Disposable {
      addObserver(fireWithInitialValue: fireWithInitialValue, on: queue) { [weak caller] event in
         guard let strongCaller = caller else { return }
         observer(strongCaller, event)
      }
   }

   public func removeAllObservers() {
      observables.forEach { $0.dispose() }
      observables.removeAll(keepingCapacity: true)
   }

   public func setValue(_ value: T, on: DispatchQueue) {
      on.async {
         self.value = value
      }
   }

   public func set(_ value: T) {
      self.value = value
   }
}
