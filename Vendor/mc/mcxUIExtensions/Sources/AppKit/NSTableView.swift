//
//  NSTableView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSTableView {

   public func addTableColumns(_ columns: NSTableColumn...) {
      for column in columns {
         addTableColumn(column)
      }
   }

   public func addTableColumns(_ columns: [NSTableColumn]) {
      for column in columns {
         addTableColumn(column)
      }
   }

   public func hideCellSeparators() {
      gridStyleMask = []
      gridColor = .clear
      intercellSpacing = .zero
   }

   public func setAutomaticRowHeight(estimatedHeight: CGFloat) {
      rowHeight = estimatedHeight
      if #available(OSX 10.13, *) {
         usesAutomaticRowHeights = true
      } else {
         rowSizeStyle = .custom
      }
   }
}
#endif
