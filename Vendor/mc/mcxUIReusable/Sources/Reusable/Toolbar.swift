//
//  Toolbar.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 01.04.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

@available(tvOS, unavailable)
open class Toolbar: UIToolbar {

   override public init(frame: CGRect) {
      // Fix for wrong value of `layoutMarginsGuide` on iOS 10 https://stackoverflow.com/a/49255958/1418981
      var adjustedFrame = frame
      if frame.size.width == 0 {
         adjustedFrame.size.width = CGFloat.leastNormalMagnitude
      }
      if frame.size.height == 0 {
         adjustedFrame.size.height = CGFloat.leastNormalMagnitude
      }
      super.init(frame: adjustedFrame)
      initializeView()
   }

   public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }

   /// Called after all KVC properties are settled.
   open func initializeView() {
      // Do something
   }
}
#endif
