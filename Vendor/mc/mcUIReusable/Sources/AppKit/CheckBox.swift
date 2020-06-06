//
//  CheckBox.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class CheckBox: NSButton {

   public var isOn: Bool {
      get {
         return state == .on
      } set {
         state = newValue ? .on : .off
      }
   }
}

#endif
