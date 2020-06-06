//
//  CGSize+Scale.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import CoreGraphics

extension CGSize {

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
}
