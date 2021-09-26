//
//  EventHandler.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 27.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public class EventHandler<Event> {

   private var callback: ((Event) -> Void)?

   public init() {
   }

   public func setHandler(on queue: DispatchQueue? = nil, _ handler: @escaping (Event) -> Void) {
      callback = { result in
         if let queue = queue {
            queue.async {
               handler(result)
            }
         } else {
            handler(result)
         }
      }
   }

   public func setHandler<T: AnyObject>(_ caller: T, on queue: DispatchQueue? = nil, _ handler: @escaping (T, Event) -> Void) {
      callback = { [weak caller] event in
         if let queue = queue {
            queue.async {
               guard let strongCaller = caller else { return }
               handler(strongCaller, event)
            }
         } else {
            guard let strongCaller = caller else { return }
            handler(strongCaller, event)
         }
      }
   }

   public func reset() {
      callback = nil
   }

   public func fire(_ event: Event) {
      callback?(event)
   }

   public func fire(_ event: Event, on queue: DispatchQueue) {
      queue.async {
         self.callback?(event)
      }
   }
}
