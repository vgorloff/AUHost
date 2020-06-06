//
//  SplitView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 01.02.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcFoundationObservables
import mcUI

open class SplitView: NSSplitView {

   private var mDividerColor: NSColor?
   private var mDividerThickness: CGFloat?

   public var backgroundColor: NSColor?

   var onAppearanceDidChanged: ((SystemAppearance) -> Void)?
   private var observers: [NotificationObserver] = []

   override open var dividerColor: NSColor {
      return mDividerColor ?? super.dividerColor
   }

   override open var dividerThickness: CGFloat {
      return mDividerThickness ?? super.dividerThickness
   }

   public init() {
      super.init(frame: NSRect())
      initializeView()
      notifySystemAppearanceDidChange()
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
      }
      super.draw(dirtyRect)
   }

   @available(OSX 10.14, *)
   override open func viewDidChangeEffectiveAppearance() {
      super.viewDidChangeEffectiveAppearance()
      notifySystemAppearanceDidChange()
   }

   open func initializeView() {
      // Do something
   }

   @objc open dynamic func setupAppearance(_: SystemAppearance) {
   }
}

extension SplitView {

   public func setDividerColor(_ value: NSColor?) {
      mDividerColor = value
   }

   public func setDividerThickness(_ value: CGFloat?) {
      mDividerThickness = value
   }

   // MARK: -

   private func notifySystemAppearanceDidChange() {
      onAppearanceDidChanged?(systemAppearance)
      setupAppearance(systemAppearance)
   }
}
#endif
