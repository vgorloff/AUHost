//
//  ScreenSize.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.10.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if !os(macOS)
import UIKit

public struct ScreenSize {

   public static var pixelSize: CGFloat {
      return 1 / UIScreen.main.scale
   }

   public static var width: CGFloat {
      return UIScreen.main.bounds.size.width
   }

   public static var height: CGFloat {
      return UIScreen.main.bounds.size.height
   }

   public static var maxLength: CGFloat {
      return max(width, height)
   }

   public static var minLength: CGFloat {
      return min(width, height)
   }

   public static func isLessThanOrEqual(_ dimension: PhoneScreenDimension) -> Bool {
      return dimension.size.width <= minLength && dimension.size.height <= maxLength
   }

   public static func isEqual(_ dimension: PhoneScreenDimension) -> Bool {
      return dimension.size.width == minLength && dimension.size.height == maxLength
   }

   public static func isLessThanOrEqual(_ dimension: PadScreenDimension) -> Bool {
      return dimension.size.width <= maxLength && dimension.size.height <= minLength
   }

   public static func isEqual(_ dimension: PadScreenDimension) -> Bool {
      return dimension.size.width == maxLength && dimension.size.height == minLength
   }
}
#endif
