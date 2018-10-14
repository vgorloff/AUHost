//
//  StackView.swift
//  WLUI
//
//  Created by Vlad Gorlov on 16.10.17.
//  Copyright © 2017 Demo. All rights reserved.
//

import AppKit

open class StackView: NSStackView {

   public convenience init(axis: NSUserInterfaceLayoutOrientation) {
      self.init()
      self.axis = axis
   }

   public init() {
      super.init(frame: CGRect())
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
   }

   public convenience init(views: NSView...) {
      self.init()
      addArrangedSubviews(views)
   }

   public convenience init(views: [NSView]) {
      self.init()
      addArrangedSubviews(views)
   }

   public required init?(coder decoder: NSCoder) {
      fatalError()
   }

   open func setupUI() {
   }

   open func setupLayout() {
   }

   open func setupHandlers() {
   }

   open func setupDefaults() {
   }
}
