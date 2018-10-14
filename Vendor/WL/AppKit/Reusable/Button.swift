//
//  Button.swift
//  WLUI
//
//  Created by Vlad Gorlov on 02.02.18.
//  Copyright © 2018 Demo. All rights reserved.
//

import AppKit

public class Button: NSButton {

   public override init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      bezelStyle = .rounded
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }
}
