//
//  NSWindow.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcUI

extension NSWindow {

   public enum Style {
      case welcome
      case `default`
   }

   public convenience init(contentRect: CGRect, style: Style) {
      switch style {
      case .welcome:
         let styleMask: NSWindow.StyleMask = [.closable, .titled, .fullSizeContentView]
         self.init(contentRect: contentRect, styleMask: styleMask, backing: .buffered, defer: true)
         titlebarAppearsTransparent = true
         titleVisibility = .hidden
         standardWindowButton(.zoomButton)?.isHidden = true
         standardWindowButton(.miniaturizeButton)?.isHidden = true
      case .default:
         let styleMask: NSWindow.StyleMask = [.closable, .titled, .miniaturizable, .resizable]
         self.init(contentRect: contentRect, styleMask: styleMask, backing: .buffered, defer: true)
      }
   }

   public func removeTitlebarAccessoryViewController(_ vc: NSTitlebarAccessoryViewController) {
      for (idx, controller) in titlebarAccessoryViewControllers.enumerated() {
         if controller == vc {
            removeTitlebarAccessoryViewController(at: idx)
            return
         }
      }
   }

   public var anchor: LayoutConstraint {
      return LayoutConstraint()
   }
}
#endif
