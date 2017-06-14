//
//  MainToolbar.swift
//  Attenuator
//
//  Created by Vlad Gorlov on 05/10/2016.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Cocoa

class MainToolbar: NSToolbar {

   let toolbarDelegate = GenericDelegate()

   var eventHandler: ((MainToolbar.Event) -> Void)?

   init(identifier: NSToolbar.Identifier, showsReloadPlugInsItem: Bool = true) {
      super.init(identifier: identifier)
      allowsUserCustomization = true
      autosavesConfiguration = true
      displayMode = .iconAndLabel
      toolbarDelegate.allowedItemIdentifiers = [.space, .flexibleSpace]
      toolbarDelegate.defaultItemIdentifiers = Event.toolbarIDs + [.flexibleSpace]
      if showsReloadPlugInsItem == false {
         toolbarDelegate.defaultItemIdentifiers = toolbarDelegate.defaultItemIdentifiers.filter {
            $0 != Event.reloadPlugIns.itemIdentifier
         }
      }
      toolbarDelegate.selectableItemIdentifiers = toolbarDelegate.allowedItemIdentifiers
      toolbarDelegate.makeItemCallback = { [unowned self] id, flag in
         guard let event = Event(id: id) else {
            return nil
         }
         return self.makeToolbarItem(event: event)
      }
      delegate = toolbarDelegate
   }

   private func makeToolbarItem(event: Event) -> NSToolbarItem {
      let item = NSToolbarItem(itemIdentifier: event.itemIdentifier)
      item.target = self
      item.action = #selector(handle(toolbarItem:))
      item.label = event.label
      item.paletteLabel = event.paletteLabel
      if event.image != nil {
         item.image = event.image
      } else if event.view != nil {
         item.view = event.view
      }
      return item
   }

   @objc private func handle(toolbarItem: NSToolbarItem) {
      guard let event = Event(id: toolbarItem.itemIdentifier) else {
         return
      }
      eventHandler?(event)
   }
}
