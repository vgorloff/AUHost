//
//  VULevelMeter.DrawingData.swift
//  Attenuator
//
//  Created by VG (DE) on 10/10/2016.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Foundation

public final class ModelDatasource {

   public private(set) var floatVertices = [Float]()
   private var width: Double = 0
   private var height: Double = 0
   private var xOffset: Double = 0
   private var yOffset: Double = 0

   public func addHorizontalLine(yPosition: Double) {
      floatVertices.append(contentsOf: [Float(xOffset), Float(yPosition),
                                             Float(xOffset + width), Float(yPosition)])
   }

   public func addVerticalLine(xPosition: Double) {
      floatVertices.append(contentsOf: [Float(xPosition), Float(yOffset),
                                             Float(xPosition), Float(yOffset + height)])
   }

   public func reset(xOffset: Double, yOffset: Double, width: Double, height: Double) {
      self.xOffset = xOffset
      self.yOffset = yOffset
      self.width = width
      self.height = height
      floatVertices.removeAll(keepingCapacity: true)
   }

}
