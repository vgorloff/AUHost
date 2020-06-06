//
//  TabBarTabViewItem.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 31.08.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import Foundation

open class TabBarTabViewItem<T>: CollectionViewItem {

   override open func loadView() {
      super.loadView()
      view.wantsLayer = true
   }

   open func configure(value: T) {
   }
}
#endif
