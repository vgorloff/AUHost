//
//  NSButton.swift
//  WLUI
//
//  Created by Vlad Gorlov on 12.08.17.
//  Copyright © 2017 Demo. All rights reserved.
//

import AppKit

extension NSButton {

   @available(OSX 10.12, *)
   public convenience init(image: NSImage) {
      self.init(image: image, target: nil, action: nil)
   }

   @available(OSX 10.12, *)
   public convenience init(image: NSImage, alternateImage: NSImage) {
      self.init(image: image, target: nil, action: nil)
      self.alternateImage = alternateImage
   }

   public convenience init(title: String) {
      if #available(OSX 10.12, *) {
         self.init(title: title, target: nil, action: nil)
      } else {
         self.init()
         self.title = title
         bezelStyle = .rounded
      }
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
}
