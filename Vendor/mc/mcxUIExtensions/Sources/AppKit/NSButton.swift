//
//  NSButton.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if os(macOS)
import AppKit

extension NSButton {

   @available(OSX 10.12, *)
   public convenience init(image: NSImage, isBordered: Bool = true) {
      self.init(image: image, target: nil, action: nil)
      self.isBordered = isBordered
   }

   @available(OSX 10.12, *)
   public convenience init(image: NSImage, alternateImage: NSImage) {
      self.init(image: image, target: nil, action: nil)
      self.alternateImage = alternateImage
   }

   public convenience init(labelWithTitle: String) {
      self.init(title: labelWithTitle)
      isBordered = false
   }

   public convenience init(title: String, isBordered: Bool = true) {
      if #available(OSX 10.12, *) {
         self.init(title: title, target: nil, action: nil)
      } else {
         self.init()
         self.title = title
         bezelStyle = .rounded
      }
      self.isBordered = isBordered
   }

   public convenience init(checkboxWithTitle: String) {
      if #available(OSX 10.12, *) {
         self.init(checkboxWithTitle: checkboxWithTitle, target: nil, action: nil)
      } else {
         self.init()
         setButtonType(.switch)
         title = checkboxWithTitle
      }
   }

   public var textColor: NSColor {
      @available(*, unavailable)
      get {
         .white
      } set {
         attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: newValue])
      }
   }
}
#endif
