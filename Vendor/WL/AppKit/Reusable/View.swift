//
//  View.swift
//  WLUI
//
//  Created by Vlad Gorlov on 16.10.17.
//  Copyright © 2017 Demo. All rights reserved.
//

import AppKit

open class View: NSView {

   public var backgroundColor: NSColor? {
      didSet {
         setNeedsDisplay(bounds)
      }
   }

   private var mIsFlipped: Bool?

   open override var isFlipped: Bool {
      return mIsFlipped ?? super.isFlipped
   }

   public convenience init(backgroundColor: NSColor) {
      self.init()
      self.backgroundColor = backgroundColor
   }

   public init() {
      super.init(frame: NSRect())
      setupUI()
      setupLayout()
      setupDataSource()
      setupHandlers()
      setupDefaults()

      if #available(OSX 10.14, *) {
      } else {
         // TODO: Update to support `highContrastLight`.
         // See: https://stackoverflow.com/q/51774587/1418981
         setupAppearance(.light)
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
      if let value = effectiveAppearance.bestMatch(from: [.aqua, .darkAqua, .accessibilityHighContrastAqua,
                                                          .accessibilityHighContrastDarkAqua]) {
         switch value {
         case .aqua:
            setupAppearance(.light)
         case .darkAqua:
            setupAppearance(.dark)
         case .accessibilityHighContrastAqua:
            setupAppearance(.highContrastLight)
         case .accessibilityHighContrastDarkAqua:
            setupAppearance(.highContrastDark)
         default:
            break
         }
      }
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

   @objc open dynamic func setupAppearance(_: SystemAppearance) {
   }
}

extension View {

   public func setIsFlipped(_ value: Bool?) {
      mIsFlipped = value
   }
}
