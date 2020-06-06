//
//  SegmentedControl.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09/01/2017.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

open class SegmentedControl: UISegmentedControl {

   override public init(items: [Any]?) {
      super.init(items: items)
      initializeView()
   }

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
      fatalError()
   }

   open func initializeView() {
      // Do something
   }
}
#endif
