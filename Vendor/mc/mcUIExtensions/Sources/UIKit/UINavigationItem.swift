//
//  UINavigationItem.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UINavigationItem {

   @available(tvOS, unavailable)
   public var allBarButtonItems: Set<UIBarButtonItem> {
      var allItems = (leftBarButtonItems ?? []) + (rightBarButtonItems ?? [])
      if let value = backBarButtonItem {
         allItems.append(value)
      }
      return Set(allItems)
   }
}
#endif
