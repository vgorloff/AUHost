//
//  NSWindowController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if os(macOS)
import AppKit
import mcUI

extension NSWindowController {

   public var anchor: LayoutConstraint {
      return LayoutConstraint()
   }
}
#endif
