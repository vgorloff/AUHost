//
//  GenericTimer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 02.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

public class GenericTimer {

   private var dispatchSourceTimer: DispatchSourceTimer?
   private var startedAt: Date?
   private let timeInterval: TimeInterval
   private let isRepeatedTimer: Bool

   public var completion: (() -> Void)?

   deinit {
      stop()
   }

   public convenience init(oneShotTimerWithTimeInterval timeInterval: Double, completion: (() -> Void)? = nil) {
      self.init(timeInterval: timeInterval, repeats: false, completion: completion)
   }

   public convenience init(repeatedTimerWithTimeInterval timeInterval: Double, completion: (() -> Void)? = nil) {
      self.init(timeInterval: timeInterval, repeats: true, completion: completion)
   }

   private init(timeInterval: TimeInterval, repeats: Bool, completion: (() -> Void)? = nil) {
      self.timeInterval = timeInterval
      isRepeatedTimer = repeats
      self.completion = completion
   }
}

extension GenericTimer {

   public var isRunning: Bool {
      return dispatchSourceTimer != nil
   }

   public var timeIntervalSinceStart: TimeInterval {
      var result: TimeInterval = 0
      if let startedAt = startedAt {
         result = abs(startedAt.timeIntervalSinceNow)
      }
      return result
   }

   public func start(queue: DispatchQueue = .main) {
      if dispatchSourceTimer == nil {
         let timer = DispatchSource.makeTimerSource(queue: queue)
         timer.setEventHandler { [weak self] in
            if self?.isRepeatedTimer == false {
               self?.stop()
               self?.completion?()
            } else {
               self?.completion?()
            }
         }
         if isRepeatedTimer {
            let intervalInMilliseconds = Int(timeInterval * 1000)
            let leewayInMilliseconds = Int(0.1 * timeInterval * 1000)
            timer.schedule(deadline: .now() + timeInterval,
                           repeating: .milliseconds(intervalInMilliseconds),
                           leeway: .milliseconds(leewayInMilliseconds))
         } else {
            timer.schedule(deadline: .now() + timeInterval)
         }
         dispatchSourceTimer = timer
         timer.resume()
      }
      startedAt = Date()
   }

   public func stop() {
      if let timer = dispatchSourceTimer {
         timer.setEventHandler(handler: nil)
         if !timer.isCancelled {
            timer.cancel()
         }
         dispatchSourceTimer = nil
      }
      startedAt = nil
   }

   public func restart() {
      stop()
      start()
   }
}
