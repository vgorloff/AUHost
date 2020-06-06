//
//  Button.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09/01/2017.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

open class Button: UIButton {

   override public init(frame: CGRect) {
      // Fix for wrong value of `layoutMarginsGuide` on iOS 10 https://stackoverflow.com/a/49255958/1418981
      var adjustedFrame = frame
      if frame.size.width == 0 {
         adjustedFrame.size.width = 10
      }
      if frame.size.height == 0 {
         adjustedFrame.size.height = 10
      }
      super.init(frame: adjustedFrame)
      setupUI()
      setupLayout()
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
      setupHandlers()
      setupDefaults()
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

   override open var intrinsicContentSize: CGSize {
      if let titleLabel = titleLabel, titleLabel.numberOfLines == 0, image == nil {
         let size = titleLabel.intrinsicContentSize
         let result = CGSize(width: size.width + contentEdgeInsets.horizontal + titleEdgeInsets.horizontal,
                             height: size.height + contentEdgeInsets.vertical + titleEdgeInsets.vertical)
         return result
      } else {
         return super.intrinsicContentSize
      }
   }

   override open func layoutSubviews() {
      super.layoutSubviews()
      if let titleLabel = titleLabel, titleLabel.numberOfLines == 0, image == nil {
         let priority = UILayoutPriority.defaultLow + 1
         if titleLabel.horizontalContentHuggingPriority != priority {
            titleLabel.horizontalContentHuggingPriority = priority
         }
         if titleLabel.verticalContentHuggingPriority != priority {
            titleLabel.verticalContentHuggingPriority = priority
         }
         let rect = titleRect(forContentRect: contentRect(forBounds: bounds))
         titleLabel.preferredMaxLayoutWidth = rect.size.width
         super.layoutSubviews()
      }
   }
}
#endif
