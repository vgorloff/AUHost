//
//  NSBitmapImageRep.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSBitmapImageRep {

   public convenience init?(pixelsWide: Int, pixelsHigh: Int, bitsPerSample: Int, samplesPerPixel: Int,
                            hasAlpha: Bool, isPlanar: Bool, colorSpaceName: NSColorSpaceName) {
      self.init(bitmapDataPlanes: nil, pixelsWide: pixelsWide, pixelsHigh: pixelsHigh,
                bitsPerSample: bitsPerSample, samplesPerPixel: samplesPerPixel, hasAlpha: hasAlpha,
                isPlanar: isPlanar, colorSpaceName: colorSpaceName, bytesPerRow: 0, bitsPerPixel: 0)
   }
}
#endif
