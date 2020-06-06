//
//  NSCollectionView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes

public class __NSCollectionViewItems: InstanceHolder<NSCollectionView> {

   public var visible: [NSCollectionViewItem] {
      let viewRect = instance.visibleRect
      var items: [(IndexPath, NSCollectionViewItem)] = []
      instance.indexPathsForVisibleItems().forEach {
         if let cell = instance.item(at: $0) {
            if cell.view.frame.intersects(viewRect) {
               items.append(($0, cell))
            }
         }
      }
      items.sort(by: { $0.0 < $1.0 })
      return items.map { $0.1 }
   }
}

extension NSCollectionView {

   public var items: __NSCollectionViewItems {
      return __NSCollectionViewItems(instance: self)
   }
}

#endif
