//
//  TextView.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 07.02.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class TextView: NSTextView {

   override public init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
      super.init(frame: frameRect, textContainer: container)
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
      translatesAutoresizingMaskIntoConstraints = false
   }

   override public init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
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
