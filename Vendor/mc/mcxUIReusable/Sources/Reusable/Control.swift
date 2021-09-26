//
//  Control.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 12/03/2017.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

open class Control: UIControl {

   private var userDefinedIntrinsicContentSize: CGSize?

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
      setupUI()
      setupLayout()
      setupDataSource()
      setupHandlers()
      setupDefaults()
   }

   public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }

   override open func awakeFromNib() {
      super.awakeFromNib()
      setupUI()
      setupLayout()
      setupDataSource()
      setupHandlers()
      setupDefaults()
   }

   override open var intrinsicContentSize: CGSize {
      return userDefinedIntrinsicContentSize ?? super.intrinsicContentSize
   }

   @objc open dynamic func setupUI() {
      // Base class does nothing.
   }

   @objc open dynamic func setupLayout() {
      // Base class does nothing.
   }

   @objc open dynamic func setupHandlers() {
      // Base class does nothing.
   }

   @objc open dynamic func setupDefaults() {
      // Base class does nothing.
   }

   @objc open dynamic func setupDataSource() {
      // Base class does nothing.
   }
}

extension Control {

   /// When passed **nil**, then system value is used.
   public func setIntrinsicContentSize(_ size: CGSize?) {
      userDefinedIntrinsicContentSize = size
   }
}
#endif
