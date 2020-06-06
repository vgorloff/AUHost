//
//  CollectionView.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 05.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class CollectionView: NSCollectionView {

   override public init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
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
#endif
