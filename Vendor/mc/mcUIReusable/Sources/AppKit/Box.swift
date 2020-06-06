//
//  Box.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 02.04.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes

public class __BoxContent: InstanceHolder<Box> {

   public var view: View {
      return instance.customContentView
   }
}

open class Box: NSBox {

   fileprivate lazy var customContentView = setupCustomContent()

   public var content: __BoxContent {
      return __BoxContent(instance: self)
   }

   override public init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      translatesAutoresizingMaskIntoConstraints = false
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
   }

   private func setupCustomContent() -> View {
      let view = View().autoresizingView()
      contentView?.addSubview(view)
      sizeToFit()
      view.frame = contentView?.bounds ?? CGRect()
      view.autoresizingMask = [.width, .height]
      contentViewMargins = CGSize()
      return view
   }

   public required init?(coder: NSCoder) {
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
