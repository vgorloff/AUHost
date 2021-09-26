//
//  Benchmark.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 12.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

public enum Benchmark {

   /// - returns: Time interval in seconds.
   /// - parameter closure: Code block to measure performance.
   public static func measure(_ closure: () -> Void) -> CFTimeInterval {
      let startTime = CFAbsoluteTimeGetCurrent()
      closure()
      return CFAbsoluteTimeGetCurrent() - startTime
   }
}
