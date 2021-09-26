//
//  NSTabViewItem.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSTabViewItem {

   public convenience init(viewController: NSViewController, label: String?, image: NSImage?) {
      self.init(viewController: viewController)
      if let label = label {
         self.label = label
      }
      self.image = image
   }
}
#endif
