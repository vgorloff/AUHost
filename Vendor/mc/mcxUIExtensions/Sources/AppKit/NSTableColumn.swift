//
//  NSTableColumn.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSTableColumn {

   public convenience init(identifier: String, title: String) {
      self.init(identifier: identifier)
      self.title = title
   }

   public convenience init(identifier: String) {
      self.init(identifier: NSUserInterfaceItemIdentifier(identifier))
   }

   public convenience init(identifier: String, resizingMask: NSTableColumn.ResizingOptions) {
      self.init(identifier: NSUserInterfaceItemIdentifier(identifier))
      self.resizingMask = resizingMask
   }
}
#endif
