//
//  StackView.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 16.10.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class StackView: NSStackView {

   public var backgroundColor: NSColor? {
      @available(*, unavailable)
      get {
         nil
      } set {
         wantsLayer = true
         layer?.backgroundColor = newValue?.cgColor
      }
   }

   public init(axis: NSUserInterfaceLayoutOrientation, spacing: CGFloat) {
      super.init(frame: CGRect.w100h100)
      self.axis = axis
      self.spacing = spacing
      commonSetup([])
   }

   public init(axis: NSUserInterfaceLayoutOrientation, views: [NSView]) {
      super.init(frame: CGRect.w100h100)
      self.axis = axis
      spacing = 0
      commonSetup(views)
   }

   public init(axis: NSUserInterfaceLayoutOrientation, views: NSView...) {
      super.init(frame: CGRect.w100h100)
      spacing = 0
      self.axis = axis
      commonSetup(views)
   }

   public init(spacing: CGFloat, views: [NSView]) {
      super.init(frame: CGRect.w100h100)
      self.spacing = spacing
      commonSetup(views)
   }

   public init(spacing: CGFloat, views: NSView...) {
      super.init(frame: CGRect.w100h100)
      self.spacing = spacing
      commonSetup(views)
   }

   public init(views: NSView...) {
      super.init(frame: CGRect.w100h100)
      spacing = 0
      commonSetup(views)
   }

   public init(views: [NSView]) {
      super.init(frame: CGRect.w100h100)
      spacing = 0
      commonSetup(views)
   }

   public init() {
      super.init(frame: CGRect.w100h100)
      spacing = 0
      commonSetup([])
   }

   private func commonSetup(_ views: [NSView]) {
      translatesAutoresizingMaskIntoConstraints = false
      if axis == .vertical {
         alignment = .leading
      }
      addArrangedSubviews(views)
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
   }

   public required init?(coder decoder: NSCoder) {
      fatalError()
   }

   @objc open dynamic func setupUI() {
   }

   @objc open dynamic func setupLayout() {
   }

   @objc open dynamic func setupHandlers() {
   }

   @objc open dynamic func setupDefaults() {
   }
}
#endif
