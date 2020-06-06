//
//  Label.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09/01/2017.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

open class Label: UILabel {

   public private(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = {
      let instance = UITapGestureRecognizer()
      isUserInteractionEnabled = true
      addGestureRecognizer(instance)
      return instance
   }()

   public var isRounded: Bool? {
      didSet {
         layoutSubviews()
      }
   }

   public var textInsets = UIEdgeInsets() {
      didSet {
         setNeedsDisplay()
      }
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
      translatesAutoresizingMaskIntoConstraints = false
      setupUI()
      setupHandlers()
   }

   public required init?(coder aDecoder: NSCoder) {
      fatalError()
   }

   override open var intrinsicContentSize: CGSize {
      let size = super.intrinsicContentSize
      return CGSize(width: size.width + textInsets.horizontal, height: size.height + textInsets.vertical)
   }

   override open func drawText(in rect: CGRect) {
      super.drawText(in: rect.insetBy(insets: textInsets))
   }

   override open func layoutSubviews() {
      super.layoutSubviews()
      if let value = isRounded {
         if value {
            let radius = 0.5 * min(bounds.height, bounds.width)
            layer.cornerRadius = radius
            layer.masksToBounds = radius > 0
         }
      }
   }

   @objc open dynamic func setupUI() {
      // Base class does nothing.
   }

   @objc open dynamic func setupHandlers() {
      // Base class does nothing.
   }
}
#endif
