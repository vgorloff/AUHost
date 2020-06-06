//
//  RecentDocumentsMenu.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08.02.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcUIExtensions

public class RecentDocumentsMenu: NSMenu {

   public enum Event {
      case selected(URL)
   }

   public var eventHandler: ((Event) -> Void)?

   public init() {
      super.init(title: "Open Recent")
   }

   public required init(coder decoder: NSCoder) {
      fatalError()
   }

   override public func update() {
      super.update()
      removeAllItems()
      let urls = NSDocumentController.shared.recentDocumentURLs
      logger.default(.view, "Recent URLs: \(urls.count)")
      let menuItems = urls.map { url in
         NSMenuItem(title: url.lastPathComponent, keyEquivalent: "") { [weak self] in
            self?.eventHandler?(.selected(url))
         }
      }
      menuItems.forEach { $0.isEnabled = true }
      addItems(menuItems)
      if !menuItems.isEmpty {
         addItem(NSMenuItem.separator())
      }
      addItem(clear)
   }
}

extension RecentDocumentsMenu {

   public var item: NSMenuItem {
      let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
      item.submenu = self
      return item
   }
}

extension RecentDocumentsMenu {

   private var clear: NSMenuItem {
      return NSMenuItem(title: "Clear Menu", action: #selector(NSDocumentController.clearRecentDocuments(_:)), keyEquivalent: "")
   }
}
#endif
