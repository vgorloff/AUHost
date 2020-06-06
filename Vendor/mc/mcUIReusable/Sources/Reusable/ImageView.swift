//
//  ImageView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09/01/2017.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

open class ImageView: UIImageView {

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
   }

   public convenience init() {
      self.init(frame: CGRect())
   }

   public convenience init(contentMode: ImageView.ContentMode) {
      self.init(frame: CGRect())
      self.contentMode = contentMode
   }

   override public init(image: UIImage?) {
      super.init(image: image)
   }

   public init(image: UIImage? = nil, contentMode: ImageView.ContentMode = .scaleToFill) {
      super.init(image: image)
      self.contentMode = contentMode
   }

   public required init?(coder aDecoder: NSCoder) {
      fatalError()
   }

   override open var intrinsicContentSize: CGSize {
      return userDefinedIntrinsicContentSize ?? super.intrinsicContentSize
   }

   @objc open dynamic func setupUI() {
      // Do something
   }

   // MARK: -

   /// When passed **nil**, then system value is used.
   public func setIntrinsicContentSize(_ size: CGSize?) {
      userDefinedIntrinsicContentSize = size
   }
}
#endif
