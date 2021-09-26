//
//  Geometry.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03/05/16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public enum Geometry {

   #if os(iOS) || os(tvOS)
   public enum Pixel {
      fileprivate static let mMainScreenOnePixel = 1 / UIScreen.main.scale
      public static var One: CGFloat {
         return mMainScreenOnePixel
      }

      public static var Half: CGFloat {
         return 0.5 * mMainScreenOnePixel
      }
   }
   #endif
}
