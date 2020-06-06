//
//  NSProgressIndicator.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcRuntime

extension NSProgressIndicator.Style: CustomStringConvertible {

   public var description: String {
      switch self {
      case .bar:
         return "bar"
      case .spinning:
         return "spinning"
      @unknown default:
         Assertion.failure("Unknown value: \"\(self)\". Please update \(#file)")
         return "Unknown"
      }
   }
}

extension NSProgressIndicator {

   public convenience init(style: NSProgressIndicator.Style, controlSize: NSControl.ControlSize = .small) {
      self.init()
      self.style = style
      self.controlSize = controlSize
   }

   public func startAnimation() {
      startAnimation(nil)
   }

   public func stopAnimation() {
      stopAnimation(nil)
   }
}
#endif
