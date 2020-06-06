//
//  Button.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 02.02.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public class Button: NSButton {

   override public init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      bezelStyle = .rounded
      translatesAutoresizingMaskIntoConstraints = false
   }

   public convenience init(title: String, titleColor: NSColor, backgroundColor: NSColor) {
      self.init(title: title, titleColor: titleColor)
      isBordered = false
      (cell as? NSButtonCell)?.backgroundColor = backgroundColor
   }

   public convenience init(title: String, titleColor: NSColor) {
      self.init(title: title)
      textColor = titleColor
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }
}
#endif
