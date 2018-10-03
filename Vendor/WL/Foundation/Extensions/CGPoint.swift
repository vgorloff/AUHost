//
//  CGPoint.swift
//  mcCore
//
//  Created by Vlad Gorlov on 22/04/16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreGraphics

public extension CGPoint {

   public init(x: Float, y: Float) {
      self.init(x: CGFloat(x), y: CGFloat(y))
   }

   public init(coordinate: CGFloat) {
      self.init(x: coordinate, y: coordinate)
   }

   public func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
      return CGPoint(x: x + dx, y: y + dy)
   }

   public var inverted: CGPoint {
      return CGPoint(x: -x, y: -y)
   }

   public func scale(by factor: CGFloat) -> CGPoint {
      return CGPoint(x: factor * x, y: factor * y)
   }
}
