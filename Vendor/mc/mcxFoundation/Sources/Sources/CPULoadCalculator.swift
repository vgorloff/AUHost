//
//  CPULoadCalculator.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Darwin
import Foundation

private func - (left: timeval, right: timeval) -> TimeInterval {
   return left.timeIntervalValue - right.timeIntervalValue
}

extension timeval {
   fileprivate var timeIntervalValue: TimeInterval {
      return TimeInterval(tv_sec) + TimeInterval(tv_usec) / 1_000_000.0
   }
}

public struct CPULoadCalculator {

   private var lastTime = CPULoadCalculator.getTime()
   private var lastCPUUsage = CPULoadCalculator.getCPUUsage()

   public init() {
   }

   public mutating func calculateCPUUsage() -> Double {

      let currentTime = CPULoadCalculator.getTime()
      let currentCPUUsage = CPULoadCalculator.getCPUUsage()

      let timeDifference = currentTime - lastTime
      let previousCPUTime = lastCPUUsage.ru_utime - lastCPUUsage.ru_stime
      let currentCPUTime = currentCPUUsage.ru_utime - currentCPUUsage.ru_stime
      let CPUTimeDifference = currentCPUTime - previousCPUTime
      let CPULoad = CPUTimeDifference / timeDifference

      lastTime = currentTime
      lastCPUUsage = currentCPUUsage

      return CPULoad
   }
}

extension CPULoadCalculator {

   private static func getTime() -> timeval {
      var time = timeval()
      gettimeofday(&time, nil)
      return time
   }

   private static func getCPUUsage() -> rusage {
      var cpuUsage = rusage()
      getrusage(RUSAGE_SELF, &cpuUsage)
      return cpuUsage
   }
}
