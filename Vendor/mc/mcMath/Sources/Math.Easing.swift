//
//  Math.Easing.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 10.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import CoreGraphics
import Foundation

// See: RBBAnimation/RBBEasingFunction.m: https://github.com/robb/RBBAnimation/blob/master/RBBAnimation/RBBEasingFunction.m
extension Math { public struct Easing {} }

extension Math.Easing {

   public enum Algorithm: Int {
      case linear, easeInQuad, easeOutQuad, easeInOutQuad
   }

   @inline(__always)
   public static func linear(_ t: CGFloat) -> CGFloat {
      return t
   }

   @inline(__always)
   public static func easeInQuad(_ t: CGFloat) -> CGFloat {
      return t * t
   }

   @inline(__always)
   public static func easeOutQuad(_ t: CGFloat) -> CGFloat {
      return t * (2 - t)
   }

   @inline(__always)
   public static func easeInOutQuad(_ t: CGFloat) -> CGFloat {
      if t < 0.5 {
         return 2 * t * t
      } else {
         return -1 + (4 - 2 * t) * t
      }
   }
}

extension Math.Easing {

   public struct Timing {

      public let start: CGFloat
      public let end: CGFloat
      public let duration: CGFloat

      init(start: CGFloat, end: CGFloat) {
         self.start = start
         self.end = end
         duration = end - start
      }

      public func multiplying(by: CGFloat) -> Timing {
         return Timing(start: start * by, end: end * by)
      }
   }

   public static func process(_ tValue: CGFloat, _ algorithm: Algorithm) -> CGFloat {
      switch algorithm {
      case .linear:
         return linear(tValue)
      case .easeInQuad:
         return easeInQuad(tValue)
      case .easeOutQuad:
         return easeOutQuad(tValue)
      case .easeInOutQuad:
         return easeInOutQuad(tValue)
      }
   }

   public static func timing(numberOfSteps: Int, _ algorithm: Algorithm) -> [Timing] {
      var result: [Timing] = []
      let linearStepSize = 1 / CGFloat(numberOfSteps)
      for step in (0 ..< numberOfSteps).reversed() {
         let linearValue = CGFloat(step) * linearStepSize
         let processedValue = process(linearValue, algorithm) // Always in range 0 ... 1
         let lastValue = result.last?.start ?? 1
         result.append(Timing(start: processedValue, end: lastValue))
      }
      result = result.reversed()
      return result
   }
}
