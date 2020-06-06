//
//  CGMutablePath.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import CoreGraphics
import mcTypes

public class __CGMutablePathAsBuilder: InstanceHolder<CGMutablePath> {

   public func addVerticalLine(in rect: CGRect, x: CGFloat) {
      instance.move(to: CGPoint(x: x, y: rect.minY))
      instance.addLine(to: CGPoint(x: x, y: rect.maxY))
   }

   public func addHorizontalLine(in rect: CGRect, y: CGFloat) {
      instance.move(to: CGPoint(x: rect.minX, y: y))
      instance.addLine(to: CGPoint(x: rect.maxX, y: y))
   }
}

extension CGMutablePath {

   public var builder: __CGMutablePathAsBuilder {
      return __CGMutablePathAsBuilder(instance: self)
   }
}
