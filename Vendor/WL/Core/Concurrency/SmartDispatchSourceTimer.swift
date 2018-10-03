//
//  SmartDispatchSourceTimer.swift
//  mcCore
//
//  Created by Vlad Gorlov on 10.11.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation

public final class SmartDispatchSourceTimer: SmartDispatchSource {

   public init(flags: DispatchSource.TimerFlags = [], queue: DispatchQueue? = nil) {
      super.init()
      dispatchSource = DispatchSource.makeTimerSource(flags: flags, queue: queue)
   }

   public func schedule(deadline: DispatchTime, repeating: DispatchTimeInterval,
                        leeway: DispatchTimeInterval = .milliseconds(0)) {
      if let timer = dispatchSource as? DispatchSourceTimer {
         timer.schedule(deadline: deadline, repeating: repeating, leeway: leeway)
      }
   }

   public func schedule(deadline: DispatchTime, repeating: TimeInterval, leeway: TimeInterval = 0) {
      if let timer = dispatchSource as? DispatchSourceTimer {
         let nanoRepeating = DispatchTimeInterval.nanoseconds(Int(repeating * 1_000_000_000))
         let nanoLeeway = DispatchTimeInterval.nanoseconds(Int(leeway * 1_000_000_000))
         timer.schedule(deadline: deadline, repeating: nanoRepeating, leeway: nanoLeeway)
      }
   }
}
