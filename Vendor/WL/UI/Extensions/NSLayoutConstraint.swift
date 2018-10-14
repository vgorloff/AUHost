//
//  NSLayoutConstraint.swift
//  mcApp
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension NSLayoutConstraint {

   public func activate() {
      isActive = true
   }
}
