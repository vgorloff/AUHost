//
//  View+Geometry.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

extension __mcUIReusableAliases.View {

   #if canImport(AppKit)
   public var center: CGPoint {
      return CGPoint(x: frame.midX, y: frame.midY)
   }
   #endif

   // https://medium.com/@joesusnick/a-uiview-extension-that-will-teach-you-an-important-lesson-about-frames-cefe1e4beb0b
   public func frameIn(_ view: __mcUIReusableAliases.View?) -> CGRect {
      if let superview = superview {
         return superview.convert(frame, to: view)
      }
      return frame
   }

   public func originIn(_ view: __mcUIReusableAliases.View?) -> CGPoint {
      if let superview = superview {
         return superview.convert(frame.origin, to: view)
      }
      return frame.origin
   }

   // https://stackoverflow.com/questions/8465659/understand-convertrecttoview-convertrectfromview-convertpointtoview-and
   public func centerIn(_ view: __mcUIReusableAliases.View?) -> CGPoint {
      if let superview = superview {
         return superview.convert(center, to: view)
      }
      return center
   }
}
