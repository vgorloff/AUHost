//
//  TabViewItem.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class TabViewItem: NSTabViewItem {
}

open class GenericTabViewItem<T: Any>: TabViewItem {

   public init(identifier: T, viewController: NSViewController) {
      super.init(identifier: identifier)
      self.viewController = viewController
   }

   public required init?(coder aDecoder: NSCoder) {
      fatalError()
   }
}
#endif
