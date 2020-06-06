//
//  TableViewDelegate.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class TableViewDelegate<T: AnyObject & NSTableViewDelegate>: NSObject, NSTableViewDelegate {

   // See also: cocoa - NSTableView - Disable Row Selection - Stack Overflow: https://stackoverflow.com/questions/7285417/nstableview-disable-row-selection
   open var isSelectionEnabled = true

   public weak var context: T?

   public init(context: T) {
      self.context = context
   }

   open func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
      guard let context = context else {
         return nil
      }
      if context.responds(to: #selector(NSTableViewDelegate.tableView(_:rowViewForRow:))) {
         return context.tableView?(tableView, rowViewForRow: row)
      } else {
         let view = tableView.makeView(TableRowView.self)
         view.separatorColor = tableView.gridColor
         return view
      }
   }

   open func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
      guard let context = context else {
         return true
      }
      if context.responds(to: #selector(NSTableViewDelegate.tableView(_:shouldSelectRow:))) {
         return context.tableView?(tableView, shouldSelectRow: row) ?? true
      } else {
         return isSelectionEnabled
      }
   }

   open func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
      guard let context = context else {
         return nil
      }
      return context.tableView?(tableView, viewFor: tableColumn, row: row)
   }
}
#endif
