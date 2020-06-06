//
//  CGSize.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import CoreGraphics
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension CGSize {

   #if os(iOS) || os(tvOS)
   static let noIntrinsicMetric = UIView.noIntrinsicMetric
   #elseif os(OSX)
   static let noIntrinsicMetric = NSView.noIntrinsicMetric
   #endif

   public init(dimension: CGFloat) {
      self.init(width: dimension, height: dimension)
   }

   public init(width: CGFloat) {
      self.init(width: width, height: 0)
   }

   public init(height: CGFloat) {
      self.init(width: 0, height: height)
   }

   #if !os(watchOS)
   public init(intrinsicWidth: CGFloat) {
      self.init(width: intrinsicWidth, height: CGSize.noIntrinsicMetric)
   }

   public init(intrinsicHeight: CGFloat) {
      self.init(width: CGSize.noIntrinsicMetric, height: intrinsicHeight)
   }
   #endif

   public func insetBy(dx: CGFloat, dy: CGFloat) -> CGSize {
      return CGSize(width: width - dx, height: height - dy)
   }

   public var isZeroSize: Bool {
      return width <= CGFloat.leastNormalMagnitude && height <= CGFloat.leastNormalMagnitude
   }

   public func with(height: CGFloat) -> CGSize {
      return CGSize(width: width, height: height)
   }

   public func with(width: CGFloat) -> CGSize {
      return CGSize(width: width, height: height)
   }

   public func withIntrinsicWith() -> CGSize {
      return CGSize(width: CGSize.noIntrinsicMetric, height: height)
   }

   public func withIntrinsicHeight() -> CGSize {
      return CGSize(width: width, height: CGSize.noIntrinsicMetric)
   }
}
