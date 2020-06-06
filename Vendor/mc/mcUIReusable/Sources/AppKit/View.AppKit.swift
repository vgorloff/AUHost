//
//  View.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 16.10.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcFoundationObservables
import mcUI

open class View: NSView {

   public struct DrawingContext {
      public let context: NSGraphicsContext
      public let bounds: CGRect
      public let dirtyRect: CGRect
   }

   private var userDefinedIntrinsicContentSize: CGSize?
   var onAppearanceDidChanged: ((SystemAppearance) -> Void)?
   private var observers: [NotificationObserver] = []
   private var drawingCallbacks: [(DrawingContext) -> Void] = []

   open var backgroundColor: NSColor? {
      didSet {
         setNeedsDisplay(bounds)
      }
   }

   private var mIsFlipped: Bool?

   override open var isFlipped: Bool {
      return mIsFlipped ?? super.isFlipped
   }

   override open var intrinsicContentSize: CGSize {
      return userDefinedIntrinsicContentSize ?? super.intrinsicContentSize
   }

   public convenience init(backgroundColor: NSColor) {
      self.init()
      self.backgroundColor = backgroundColor
   }

   public init() {
      super.init(frame: NSRect())
      commonSetup()
   }

   override public init(frame: NSRect) {
      super.init(frame: frame)
      commonSetup()
   }

   private func commonSetup() {
      translatesAutoresizingMaskIntoConstraints = false
      setupUI()
      notifySystemAppearanceDidChange()
      setupLayout()
      setupHandlers()
      setupDefaults()
      if #available(OSX 10.14, *) {
      } else {
         // FIXME: Not really tested.
         let name = NSWorkspace.accessibilityDisplayOptionsDidChangeNotification
         observers.append(NotificationObserver(name: name) { [weak self] _ in
            self?.notifySystemAppearanceDidChange()
         })
      }
   }

   public required init?(coder decoder: NSCoder) {
      fatalError()
   }

   override open func draw(_ dirtyRect: NSRect) {
      if let backgroundColor = backgroundColor {
         backgroundColor.setFill()
         dirtyRect.fill()
      } else {
         super.draw(dirtyRect)
      }
      if let ctx = NSGraphicsContext.current {
         drawingCallbacks.forEach { $0(DrawingContext(context: ctx, bounds: bounds, dirtyRect: dirtyRect)) }
      }
   }

   @available(OSX 10.14, *)
   override open func viewDidChangeEffectiveAppearance() {
      super.viewDidChangeEffectiveAppearance()
      notifySystemAppearanceDidChange()
   }

   @objc open dynamic func setupUI() {
   }

   @objc open dynamic func setupLayout() {
   }

   @objc open dynamic func setupHandlers() {
   }

   @objc open dynamic func setupDefaults() {
   }

   @objc open dynamic func setupAppearance(_: SystemAppearance) {
   }
}

extension View {

   public func setIsFlipped(_ value: Bool?) {
      mIsFlipped = value
   }

   /// When passed **nil**, then system value is used.
   public func setIntrinsicContentSize(_ size: CGSize?) {
      userDefinedIntrinsicContentSize = size
   }

   public func addDrawingBlock<T: AnyObject>(_ context: T, _ callback: @escaping (T, DrawingContext) -> Void) {
      drawingCallbacks.append { [weak context] drawingContext in guard let ctx = context else { return }
         callback(ctx, drawingContext)
      }
   }

   // MARK: -

   private func notifySystemAppearanceDidChange() {
      onAppearanceDidChanged?(systemAppearance)
      setupAppearance(systemAppearance)
   }
}
#endif
