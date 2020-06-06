//
//  Scroller.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 07.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class Scroller: NSScroller {

   override public init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
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
