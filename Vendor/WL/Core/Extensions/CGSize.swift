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
