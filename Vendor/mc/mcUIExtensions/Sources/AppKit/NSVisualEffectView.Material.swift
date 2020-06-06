//
//  NSVisualEffectView.Material.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSVisualEffectView.Material: CustomStringConvertible {
   public var description: String {
      switch self {
      case .appearanceBased:
         return "appearanceBased"
      case .titlebar:
         return "titlebar"
      case .selection:
         return "selection"
      case .menu:
         return "menu"
      case .popover:
         return "popover"
      case .sidebar:
         return "sidebar"
      case .headerView:
         return "headerView"
      case .sheet:
         return "sheet"
      case .windowBackground:
         return "windowBackground"
      case .hudWindow:
         return "hudWindow"
      case .fullScreenUI:
         return "fullScreenUI"
      case .toolTip:
         return "toolTip"
      case .contentBackground:
         return "contentBackground"
      case .underWindowBackground:
         return "underWindowBackground"
      case .underPageBackground:
         return "underPageBackground"
      case .light:
         return "light"
      case .dark:
         return "dark"
      case .mediumLight:
         return "mediumLight"
      case .ultraDark:
         return "ultraDark"
      @unknown default:
         assertionFailure("Unknown value: \"\(self)\". Please update \(#file)")
         return "Unknown"
      }
   }
}
#endif
