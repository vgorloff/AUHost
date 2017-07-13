//
//  CGSize.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 17.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import CoreGraphics

#if os(iOS)
   import UIKit

   extension CGSize: StringRepresentable {
      public var stringValue: String {
         return NSStringFromCGSize(self)
      }
   }
#endif

extension CGSize {

   public init(squareDimension: CGFloat) {
      width = squareDimension
      height = squareDimension
   }

   public func scale(by factor: CGFloat) -> CGSize {
      return CGSize(width: factor * width, height: factor * height)
   }

   public func insetBy(dw: CGFloat, dh: CGFloat) -> CGSize {
      return CGSize(width: width - dw, height: height - dh)
   }

   public var isZeroSize: Bool {
      return width <= CGFloat.leastNormalMagnitude && height <= CGFloat.leastNormalMagnitude
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

   init(squareSide: CGFloat) {
      self.init(width: squareSide, height: squareSide)
   }
}
