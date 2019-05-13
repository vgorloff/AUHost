//
//  View.swift
//  WLUI
//
//  Created by Vlad Gorlov on 16.10.17.
//  Copyright © 2017 Demo. All rights reserved.
//

import AppKit
import mcFoundation
import mcUI

open class View: NSView {

   private var userDefinedIntrinsicContentSize: CGSize?
   var onAppearanceDidChanged: ((SystemAppearance) -> Void)?
   private var observers: [NotificationObserver] = []

   public var backgroundColor: NSColor? {
      didSet {
         setNeedsDisplay(bounds)
      }
   }

   private var mIsFlipped: Bool?

   open override var isFlipped: Bool {
      return mIsFlipped ?? super.isFlipped
   }

   open override var intrinsicContentSize: CGSize {
      return userDefinedIntrinsicContentSize ?? super.intrinsicContentSize
   }

   public convenience init(backgroundColor: NSColor) {
      self.init()
      self.backgroundColor = backgroundColor
   }

   public init() {
      super.init(frame: NSRect())
      setupUI()
      notifySystemAppearanceDidChange()
      setupLayout()
      setupDataSource()
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

   open override func draw(_ dirtyRect: NSRect) {
      if let backgroundColor = backgroundColor {
         backgroundColor.setFill()
         dirtyRect.fill()
      } else {
         super.draw(dirtyRect)
      }
   }

   @available(OSX 10.14, *)
   open override func viewDidChangeEffectiveAppearance() {
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

   @objc open dynamic func setupDataSource() {
   }

   @objc open dynamic func setupAppearance(_ appearance: SystemAppearance) {
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

   // MARK: -

   private func notifySystemAppearanceDidChange() {
      onAppearanceDidChanged?(systemAppearance)
      setupAppearance(systemAppearance)
   }
}
