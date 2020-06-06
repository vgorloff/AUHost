//
//  SecureTextField.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 02.04.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class SecureTextField: NSSecureTextField {

   override public init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      translatesAutoresizingMaskIntoConstraints = false
   }

   public required init?(coder decoder: NSCoder) {
      fatalError()
   }
}

#endif
