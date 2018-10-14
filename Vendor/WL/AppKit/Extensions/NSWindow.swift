//
//  NSWindow.swift
//  WLUI
//
//  Created by Vlad Gorlov on 29.01.18.
//  Copyright © 2018 Demo. All rights reserved.
//

import AppKit

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
}
