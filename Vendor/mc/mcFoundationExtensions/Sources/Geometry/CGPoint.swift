//
//  CGPoint.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import CoreGraphics

extension CGPoint {

   public init(x: Float, y: Float) {
      self.init(x: CGFloat(x), y: CGFloat(y))
   }

   public init(coordinate: CGFloat) {
      self.init(x: coordinate, y: coordinate)
   }

   public func offsetBy(point: CGPoint) -> CGPoint {
      return CGPoint(x: x + point.x, y: y + point.y)
   }

   public func subtract(point: CGPoint) -> CGPoint {
      return CGPoint(x: x - point.x, y: y - point.y)
   }

   public func add(point: CGPoint) -> CGPoint {
      return CGPoint(x: x + point.x, y: y + point.y)
   }

   public func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
      return CGPoint(x: x + dx, y: y + dy)
   }

   public func offsetX(dx: CGFloat) -> CGPoint {
      return offsetBy(dx: dx, dy: 0)
   }

   public func offsetY(dy: CGFloat) -> CGPoint {
      return offsetBy(dx: 0, dy: dy)
   }

   public var inverted: CGPoint {
      return CGPoint(x: -x, y: -y)
   }

   public func scale(by factor: CGFloat) -> CGPoint {
      return CGPoint(x: factor * x, y: factor * y)
   }
}
