//
//  CGSize.swift
//  mcCore
//
//  Created by Vlad Gorlov on 17.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import CoreGraphics
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension CGSize {

   public init(squareSide: CGFloat) {
      self.init(width: squareSide, height: squareSide)
   }

   public init(width: CGFloat) {
      self.init(width: width, height: 0)
   }

   public init(height: CGFloat) {
      self.init(width: 0, height: height)
   }

   public init(intrinsicWidth: CGFloat) {
      #if os(iOS) || os(tvOS) || os(watchOS)
      self.init(width: intrinsicWidth, height: UIView.noIntrinsicMetric)
      #elseif os(OSX)
      self.init(width: intrinsicWidth, height: NSView.noIntrinsicMetric)
      #endif
   }

   public init(intrinsicHeight: CGFloat) {
      #if os(iOS) || os(tvOS) || os(watchOS)
      self.init(width: UIView.noIntrinsicMetric, height: intrinsicHeight)
      #elseif os(OSX)
      self.init(width: NSView.noIntrinsicMetric, height: intrinsicHeight)
      #endif
   }

   public func scale(by factor: CGFloat) -> CGSize {
      return CGSize(width: factor * width, height: factor * height)
   }

   public func scaleToFit(width: CGFloat) -> CGSize {
      let factor = width / self.width
      return scale(by: factor)
   }

   public func scaleWidth(by factor: CGFloat) -> CGSize {
      return CGSize(width: factor * width, height: height)
   }

   public func scaleHeight(by factor: CGFloat) -> CGSize {
      return CGSize(width: width, height: factor * height)
   }

   public func insetBy(dx: CGFloat, dy: CGFloat) -> CGSize {
      return CGSize(width: width - dx, height: height - dy)
   }

   public var isZeroSize: Bool {
      return width <= CGFloat.leastNormalMagnitude && height <= CGFloat.leastNormalMagnitude
   }
}

extension CGSize: Comparable {

   public static func < (lhs: CGSize, rhs: CGSize) -> Bool {
      return lhs.width < rhs.width || lhs.height < rhs.height
   }
}

private extension CGSize {

   enum ResizeMethod {
      case fit
      case fill
   }

   func aspectResize(toSize newSize: CGSize, withResizeMethod: ResizeMethod) -> CGRect {
      if equalTo(newSize) {
         return CGRect(origin: CGPoint.zero, size: self)
      } else if equalTo(CGSize.zero) {
         let origin = CGPoint(x: 0.5 * newSize.width, y: 0.5 * newSize.height)
         return CGRect(origin: origin, size: self)
      } else if newSize.equalTo(CGSize.zero) {
         let origin = CGPoint(x: 0.5 * -width, y: 0.5 * -height)
         return CGRect(origin: origin, size: self)
      } else {
         let aspectCurrent = width / height
         let aspectNew = newSize.width / newSize.height
         if aspectNew == aspectCurrent {
            return CGRect(origin: CGPoint.zero, size: newSize)
         }
         var scalledSize: CGSize
         switch withResizeMethod {
         case .fill:
            if aspectNew < aspectCurrent {
               scalledSize = CGSize(width: aspectCurrent * newSize.height, height: newSize.height)
            } else {
               scalledSize = CGSize(width: newSize.width, height: newSize.width / aspectCurrent)
            }
         case .fit:
            if aspectNew > aspectCurrent {
               scalledSize = CGSize(width: aspectCurrent * newSize.height, height: newSize.height)
            } else {
               scalledSize = CGSize(width: newSize.width, height: newSize.width / aspectCurrent)
            }
         }
         var resultRect = CGRect(origin: CGPoint.zero, size: scalledSize)
         resultRect.origin.x = 0.5 * (newSize.width - scalledSize.width)
         resultRect.origin.y = 0.5 * (newSize.height - scalledSize.height)
         return resultRect
      }
   }
}

public extension CGSize {

   func aspectFit(toSize newSize: CGSize) -> CGRect {
      return aspectResize(toSize: newSize, withResizeMethod: .fit)
   }

   func aspectFill(toSize newSize: CGSize) -> CGRect {
      return aspectResize(toSize: newSize, withResizeMethod: .fill)
   }
}
