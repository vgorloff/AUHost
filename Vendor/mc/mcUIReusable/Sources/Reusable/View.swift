//
//  View.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09/01/2017.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

open class View: UIView {

   public struct DrawingContext {
      public let context: CGContext
      public let bounds: CGRect
      public let dirtyRect: CGRect
   }

   private var userDefinedIntrinsicContentSize: CGSize?
   private var drawingCallbacks: [(DrawingContext) -> Void] = []

   public private(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = {
      let instance = UITapGestureRecognizer()
      addGestureRecognizer(instance)
      return instance
   }()

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

   override open func draw(_ rect: CGRect) {
      super.draw(rect)
      if let ctx = UIGraphicsGetCurrentContext() {
         drawingCallbacks.forEach { $0(DrawingContext(context: ctx, bounds: bounds, dirtyRect: rect)) }
      }
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

extension View {

   /// When passed **nil**, then system value is used.
   public func setIntrinsicContentSize(_ size: CGSize?) {
      userDefinedIntrinsicContentSize = size
   }

   public func addDrawingBlock<T: AnyObject>(_ context: T, _ callback: @escaping (T, DrawingContext) -> Void) {
      drawingCallbacks.append { [weak context] drawingContext in guard let ctx = context else { return }
         callback(ctx, drawingContext)
      }
   }
}
#endif
