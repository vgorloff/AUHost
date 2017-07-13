//
//  AppConfig.swift
//  WaveLabs
//
//  Created by VG (DE) on 17.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

#if os(OSX)
import AppKit
import Foundation

struct AppConfig {

   static var applicationClass: NSApplication.Type {
      guard let principalClassName = Bundle.main.infoDictionary?["NSPrincipalClass"] as? String else {
         fatalError("Seems like `NSPrincipalClass` is missed in `Info.plist` file.")
      }
      guard let principalClass = NSClassFromString(principalClassName) as? NSApplication.Type else {
         fatalError("Unable to create `NSApplication` class for `\(principalClassName)`")
      }
      return principalClass
   }

   static var mainStoryboard: NSStoryboard {
      guard let mainStoryboardName = Bundle.main.infoDictionary?["NSMainStoryboardFile"] as? String else {
         fatalError("Seems like `NSMainStoryboardFile` is missed in `Info.plist` file.")
      }

      let storyboard = NSStoryboard(name: NSStoryboard.Name(mainStoryboardName), bundle: Bundle.main)
      return storyboard
   }

   static var mainMenu: NSNib {
      guard let nib = NSNib(nibNamed: NSNib.Name("MainMenu"), bundle: Bundle.main) else {
         fatalError("Resource `MainMenu.xib` is not found in the bundle `\(Bundle.main.bundlePath)`")
      }
      return nib
   }

   static var mainWindowController: NSWindowController {
      guard let wc = mainStoryboard.instantiateInitialController() as? NSWindowController else {
         fatalError("Initial controller is not `NSWindowController` in storyboard `\(mainStoryboard)`")
      }
      return wc
   }
}
#endif
