//
//  GenericTabViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 31.08.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import Foundation

open class GenericTabViewController<ItemType: Equatable>: TabViewController {

   public var items: [GenericTabViewItem<ItemType>] {
      get {
         return tabViewItems.compactMap { $0 as? GenericTabViewItem<ItemType> }
      } set {
         tabViewItems = newValue
      }
   }

   public func select(itemIdentifier: ItemType) {
      if let itemIndex = index(of: itemIdentifier) {
         if selectedTabViewItemIndex != itemIndex {
            selectedTabViewItemIndex = itemIndex
         }
      }
   }

   public func index(of itemIdentifier: ItemType) -> Int? {
      for (index, element) in tabViewItems.enumerated() {
         if let identifier = element.identifier as? ItemType, identifier == itemIdentifier {
            return index
         }
      }
      return nil
   }

   public func item(with itemIdentifier: ItemType) -> GenericTabViewItem<ItemType>? {
      for element in tabViewItems {
         if let identifier = element.identifier as? ItemType, identifier == itemIdentifier {
            return element as? GenericTabViewItem<ItemType>
         }
      }
      return nil
   }
}
#endif
