//
//  CPULoadCalculator.swift
//  WLCore
//
//  Created by Vlad Gorlov on 08.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Darwin

public final class CPULoadCalculator {

   private var lastTime: timeval
   private var lastCpuUsage: rusage

   public init() {
      let lLastTime = UnsafeMutablePointer<timeval>.alloc(1)
      gettimeofday(lLastTime, nil)
      lastTime = lLastTime.memory

      let lLastCpuUsage = UnsafeMutablePointer<rusage>.alloc(1)
      getrusage(RUSAGE_SELF, lLastCpuUsage)
      lastCpuUsage = lLastCpuUsage.memory
   }

   deinit {
   }

   private func secondsFromTimeVal(time: timeval) -> Double {
      return Double(time.tv_sec) + Double(time.tv_usec) / 1000000.0
   }

   public func getCPUUsage() -> Double {
      let lTime = UnsafeMutablePointer<timeval>.alloc(1)
      gettimeofday(lTime, nil)
      let currTime = lTime.memory

      let lCpuUsage = UnsafeMutablePointer<rusage>.alloc(1)
      getrusage(RUSAGE_SELF, lCpuUsage)
      let currCpuUsage = lCpuUsage.memory

      let timeDiff = secondsFromTimeVal(currTime) - secondsFromTimeVal(lastTime)
      let prevTimeCpu = secondsFromTimeVal(lastCpuUsage.ru_utime) - secondsFromTimeVal(lastCpuUsage.ru_stime)
      let currTimeCpu = secondsFromTimeVal(currCpuUsage.ru_utime) - secondsFromTimeVal(currCpuUsage.ru_stime)
      let timeDiffCpu = currTimeCpu - prevTimeCpu
      let cpuLoad = timeDiffCpu / timeDiff
      lastTime = currTime
      lastCpuUsage = currCpuUsage
      return cpuLoad
   }
}
