//
//  Toolbar.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 15.07.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public protocol ToolbarEvent: CaseIterable {

   var id: String { get }
   var label: String { get }
   var view: NSView? { get }
   var image: NSImage? { get }
   var paletteLabel: String { get }
}

extension ToolbarEvent {

   public init?(id: NSToolbarItem.Identifier) {
      guard let event = (Self.allCases.filter { $0.itemIdentifier == id }).first else {
         return nil
      }
      self = event
   }

   public var itemIdentifier: NSToolbarItem.Identifier {
      return NSToolbarItem.Identifier(id)
   }

   public var paletteLabel: String {
      return label
   }

   public var view: NSView? {
      return nil
   }

   public var image: NSImage? {
      return nil
   }

   public static var toolbarIDs: [NSToolbarItem.Identifier] {
      return allCases.map { $0.itemIdentifier }
   }
}

open class Toolbar<T: ToolbarEvent>: NSToolbar {

   public var eventHandler: ((T) -> Void)?

   public let toolbarDelegate = GenericDelegate()

   override public init(identifier: NSToolbar.Identifier) {
      super.init(identifier: identifier)

      allowsUserCustomization = true
      autosavesConfiguration = true
      displayMode = .iconOnly
      delegate = toolbarDelegate
      toolbarDelegate.makeItemCallback = { [weak self] id, _ in
         guard let event = T(id: id) else {
            return nil
         }
         return self?.makeToolbarItem(event: event)
      }

      setupUI()
      setupHandlers()
   }

   private func makeToolbarItem(event: T) -> NSToolbarItem {
      let item = NSToolbarItem(itemIdentifier: event.itemIdentifier)
      item.setHandler { [weak self] in
         guard let event = T(id: event.itemIdentifier) else {
            return
         }
         self?.eventHandler?(event)
      }
      item.label = event.label
      item.paletteLabel = event.paletteLabel
      if event.image != nil {
         item.image = event.image
      } else if event.view != nil {
         item.view = event.view
      }
      return item
   }

   open func setupUI() {
   }

   open func setupHandlers() {
   }
}
#endif
