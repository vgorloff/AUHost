//
//  CGContext.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 21.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import CoreGraphics

extension CGContext {

   public static func context(width: Int, height: Int, bitsPerComponent: Int = 8,
                              space: CGColorSpace = CGColorSpaceCreateDeviceRGB(),
                              bitmapInfo: UInt32) -> CGContext? {
      return CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: 0,
                       space: space, bitmapInfo: bitmapInfo)
   }
}
