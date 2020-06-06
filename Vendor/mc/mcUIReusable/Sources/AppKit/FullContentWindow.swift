//
//  FullContentWindow.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 13.10.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public class FullContentWindow: Window {

   private var buttons: [NSButton] = []

   public let titleBarAccessoryViewController = TitlebarAccessoryViewController()
   private lazy var titleBarHeight = calculatedTitleBarHeight
   private let titleBarLeadingOffset: CGFloat?
   private var originalLeadingOffsets: [CGFloat] = []

   public init(contentRect: NSRect, titleBarHeight: CGFloat, titleBarLeadingOffset: CGFloat? = nil) {
      self.titleBarLeadingOffset = titleBarLeadingOffset
      let styleMask: NSWindow.StyleMask = [.closable, .titled, .miniaturizable, .resizable, .fullSizeContentView]
      super.init(contentRect: contentRect, styleMask: styleMask, backing: .buffered, defer: true)
      titleVisibility = .hidden
      titlebarAppearsTransparent = true
      buttons = [NSWindow.ButtonType.closeButton, .miniaturizeButton, .zoomButton].compactMap {
         standardWindowButton($0)
      }
      var accessoryViewHeight = titleBarHeight - calculatedTitleBarHeight
      accessoryViewHeight = max(0, accessoryViewHeight)
      titleBarAccessoryViewController.view.frame = CGRect(dimension: accessoryViewHeight) // Width not used.
      if accessoryViewHeight > 0 {
         addTitlebarAccessoryViewController(titleBarAccessoryViewController)
      }
      self.titleBarHeight = max(titleBarHeight, calculatedTitleBarHeight)
   }

   override public func layoutIfNeeded() {
      super.layoutIfNeeded()
      if originalLeadingOffsets.isEmpty {
         let firstButtonOffset = buttons.first?.frame.origin.x ?? 0
         originalLeadingOffsets = buttons.map { $0.frame.origin.x - firstButtonOffset }
      }
      if titleBarAccessoryViewController.view.frame.height > 0, !titleBarAccessoryViewController.isHidden {
         setupButtons()
      }
   }
}

extension FullContentWindow {

   public var standardWindowButtonsRect: CGRect {
      var result = CGRect()
      if let firstButton = buttons.first, let lastButton = buttons.last {
         let leadingOffset = firstButton.frame.origin.x
         let maxX = lastButton.frame.maxX
         result = CGRect(x: leadingOffset, y: 0, width: maxX - leadingOffset, height: titleBarHeight)
         if let titleBarLeadingOffset = titleBarLeadingOffset {
            result = result.offsetBy(dx: titleBarLeadingOffset - leadingOffset, dy: 0)
         }
      }
      return result
   }
}

extension FullContentWindow {

   private func setupButtons() {
      let barHeight = calculatedTitleBarHeight
      for (idx, button) in buttons.enumerated() {
         let coordY = (barHeight - button.frame.size.height) * 0.5
         var coordX = button.frame.origin.x
         if let titleBarLeadingOffset = titleBarLeadingOffset {
            coordX = titleBarLeadingOffset + originalLeadingOffsets[idx]
         }
         button.setFrameOrigin(CGPoint(x: coordX, y: coordY))
      }
   }

   private var calculatedTitleBarHeight: CGFloat {
      let result = contentRect(forFrameRect: frame).height - contentLayoutRect.height
      return result
   }
}
#endif
