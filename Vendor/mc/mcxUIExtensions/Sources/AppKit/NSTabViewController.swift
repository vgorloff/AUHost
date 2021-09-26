//
//  NSTabViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSTabViewController {

   @discardableResult
   public func addTabViewItem(_ tabViewItem: NSViewController, label: String? = nil, image: NSImage? = nil) -> NSTabViewItem {
      let item = NSTabViewItem(viewController: tabViewItem, label: label, image: image)
      addTabViewItem(item)
      return item
   }

   public func viewControllers<T>(ofType: T.Type) -> [T] {
      return tabViewItems.compactMap { $0.viewController as? T }
   }
}
#endif
