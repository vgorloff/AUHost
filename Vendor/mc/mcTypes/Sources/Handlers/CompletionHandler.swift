//
//  CompletionHandler.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public class CompletionHandler {

   private var callback: (() -> Void)?

   public init() {
   }

   public func setHandler<T: AnyObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
      callback = { [weak caller] in guard let caller = caller else { return }
         handler(caller)
      }
   }

   public func setHandler(_ handler: @escaping () -> Void) {
      callback = handler
   }

   public func reset() {
      callback = nil
   }

   public func fire() {
      callback?()
   }

   public func fire(on queue: DispatchQueue) {
      queue.async {
         self.callback?()
      }
   }

   public func fire(on queue: DispatchQueue, delay: TimeInterval) {
       queue.asyncAfter(deadline: .now() + delay) {
           self.callback?()
       }
   }
}
