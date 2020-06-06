//
//  WaveformDrawingDataProvider.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 28.01.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import CoreGraphics

public final class WaveformDrawingDataProvider {

   public private(set) var points = [CGPoint]()
   private var width: CGFloat = 0
   private var height: CGFloat = 0
   private var xOffset: CGFloat = 0
   private var yOffset: CGFloat = 0

   public init() {
   }

   public func addVerticalLineAtXPosition(xPosition: CGFloat, valueMin: CGFloat, valueMax: CGFloat) {
      let middleY = 0.5 * height
      let halfAmplitude = middleY
      points.append(CGPoint(x: xPosition, y: yOffset + middleY - halfAmplitude * valueMin))
      points.append(CGPoint(x: xPosition, y: yOffset + middleY - halfAmplitude * valueMax))
   }

   public func reset(xOffset: CGFloat, yOffset: CGFloat, width: CGFloat, height: CGFloat) {
      self.xOffset = xOffset
      self.yOffset = yOffset
      self.width = width
      self.height = height
      points.removeAll(keepingCapacity: true)
   }
}
