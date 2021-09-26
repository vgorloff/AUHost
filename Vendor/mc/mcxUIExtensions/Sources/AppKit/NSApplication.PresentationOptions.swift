//
//  NSApplication.PresentationOptions.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSApplication.PresentationOptions: CustomReflectable {

   public var customMirror: Mirror {
      var children: [(String?, Any)] = [("autoHideDock", contains(.autoHideDock)),
                                        ("hideDock", contains(.hideDock)),
                                        ("autoHideMenuBar", contains(.autoHideMenuBar)),
                                        ("hideMenuBar", contains(.hideMenuBar)),
                                        ("disableAppleMenu", contains(.disableAppleMenu)),
                                        ("disableProcessSwitching", contains(.disableProcessSwitching)),
                                        ("disableForceQuit", contains(.disableForceQuit)),
                                        ("disableSessionTermination", contains(.disableSessionTermination)),
                                        ("disableHideApplication", contains(.disableHideApplication)),
                                        ("disableMenuBarTransparency", contains(.disableMenuBarTransparency)),
                                        ("fullScreen", contains(.fullScreen)),
                                        ("autoHideToolbar", contains(.autoHideToolbar))]
      if #available(OSX 10.11.2, *) {
         children.append(("disableCursorLocationAssistance", contains(.disableCursorLocationAssistance)))
      }
      return Mirror(self, children: children)
   }
}
#endif
