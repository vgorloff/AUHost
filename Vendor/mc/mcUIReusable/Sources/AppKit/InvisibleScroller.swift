//
//  InvisibleScroller.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 31.08.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import Foundation

// Disabling scroll view indicators.
// See: https://stackoverflow.com/questions/9364953/hide-scrollers-while-leaving-scrolling-itself-enabled-in-nsscrollview
public class InvisibleScroller: Scroller {

   override public class var isCompatibleWithOverlayScrollers: Bool {
      return true
   }

   override public class func scrollerWidth(for controlSize: NSControl.ControlSize, scrollerStyle: NSScroller.Style) -> CGFloat {
      return CGFloat.leastNormalMagnitude // Dimension of scroller is equal to `FLT_MIN`
   }
}

extension InvisibleScroller {

   override public func setupUI() {
      // Below assignments not really needed, but why not.
      scrollerStyle = .overlay
      alphaValue = 0
   }
}
#endif
