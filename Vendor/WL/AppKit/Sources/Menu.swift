//
//  Menu.swift
//  WLUI
//
//  Created by Vlad Gorlov on 07.02.18.
//  Copyright © 2018 Demo. All rights reserved.
//

import AppKit

// See `Menus and Popovers in Menu Bar Apps for macOS`: https://www.raywenderlich.com/165853/menus-popovers-menu-bar-apps-macos
// See `Automatic Menu Enabling` https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/MenuList/Articles/EnablingMenuItems.html
// See `Enabling the application menu's "Preferences" menu item on Mac OS X` https://developer.apple.com/library/content/qa/qa1552/_index.html

public struct Menu {

   private static let applicationName = ProcessInfo.processInfo.processName

   public struct App {
   }

   public struct File {
   }

   public struct Edit {
   }

   public struct View {
   }

   public struct Window {
   }

   public struct Help {
   }

   public static var separator: NSMenuItem {
      return .separator()
   }
}

extension Menu.App {

   public static var about: NSMenuItem {
      return NSMenuItem(title: "About \(Menu.applicationName)",
                        action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
   }

   public static func preferences(handler: @escaping () -> Void) -> NSMenuItem {
      return NSMenuItem(title: "Preferences…", keyEquivalent: ",", handler: handler)
   }

   public static func services(submenu: NSMenu) -> NSMenuItem {
      let menuItem = NSMenuItem(title: "Services", action: nil, keyEquivalent: "")
      menuItem.submenu = submenu
      return menuItem
   }

   public static var hide: NSMenuItem {
      return NSMenuItem(title: "Hide \(Menu.applicationName)",
                        action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
   }

   public static var hideOthers: NSMenuItem {
      let item = NSMenuItem(title: "Hide Others",
                            action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
      item.keyEquivalentModifierMask = [.command, .option]
      return item
   }

   public static var showAll: NSMenuItem {
      return NSMenuItem(title: "Show All",
                        action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
   }

   public static var quit: NSMenuItem {
      return NSMenuItem(title: "Quit \(Menu.applicationName)",
                        action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
   }
}

extension Menu.File {

   public static var new: NSMenuItem {
      return NSMenuItem(title: "New", action: #selector(NSDocumentController.newDocument(_:)), keyEquivalent: "n")
   }

   public static var open: NSMenuItem {
      return NSMenuItem(title: "Open…", action: #selector(NSDocumentController.openDocument(_:)), keyEquivalent: "o")
   }

   public static func open(handler: @escaping () -> Void) -> NSMenuItem {
      return NSMenuItem(title: "Open…", keyEquivalent: "o", handler: handler)
   }

   public static var close: NSMenuItem {
      return NSMenuItem(title: "Close", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w")
   }

   public static var save: NSMenuItem {
      return NSMenuItem(title: "Save…", action: #selector(NSDocument.save(_:)), keyEquivalent: "s")
   }

   public static var saveAs: NSMenuItem {
      return NSMenuItem(title: "Save As…", action: #selector(NSDocument.saveAs(_:)), keyEquivalent: "S")
   }

   public static var revertToSaved: NSMenuItem {
      return NSMenuItem(title: "Revert to Saved", action: #selector(NSDocument.revertToSaved(_:)), keyEquivalent: "r")
   }

   public static var pageSetup: NSMenuItem {
      let item = NSMenuItem(title: "Page Setup…", action: #selector(NSDocument.runPageLayout(_:)), keyEquivalent: "p")
      item.keyEquivalentModifierMask = [.command, .shift]
      return item
   }

   public static var print: NSMenuItem {
      return NSMenuItem(title: "Print…", action: #selector(NSDocument.printDocument(_:)), keyEquivalent: "p")
   }
}

extension Menu.Edit {

   public static var copy: NSMenuItem {
      return NSMenuItem(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
   }

   public static var selectAll: NSMenuItem {
      return NSMenuItem(title: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
   }
}

extension Menu.View {

   public static var showToolbar: NSMenuItem {
      let item = NSMenuItem(title: "Show Toolbar", action: #selector(NSWindow.toggleToolbarShown(_:)), keyEquivalent: "t")
      item.keyEquivalentModifierMask = [.option, .command]
      return item
   }

   public static var toggleFullScreen: NSMenuItem {
      let item = NSMenuItem(title: "Enter Full Screen", action: #selector(NSWindow.toggleFullScreen(_:)), keyEquivalent: "f")
      item.keyEquivalentModifierMask = [.control, .command]
      return item
   }
}

extension Menu.Window {

   public static var minimize: NSMenuItem {
      return NSMenuItem(title: "Minimize", action: #selector(NSWindow.performMiniaturize(_:)), keyEquivalent: "m")
   }

   public static var zoom: NSMenuItem {
      return NSMenuItem(title: "Zoom", action: #selector(NSWindow.performZoom(_:)), keyEquivalent: "")
   }

   public static var bringAllToFront: NSMenuItem {
      return NSMenuItem(title: "Bring All to Front", action: #selector(NSApplication.arrangeInFront(_:)), keyEquivalent: "")
   }
}

extension Menu.Help {

   public static var help: NSMenuItem {
      return NSMenuItem(title: "\(Menu.applicationName) Help", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "?")
   }
}
