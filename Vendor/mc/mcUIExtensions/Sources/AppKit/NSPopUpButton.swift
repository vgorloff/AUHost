//
//  NSPopUpButton.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSPopUpButton {

   public func addItem(withTitle title: String, value: Any) {
      addItem(withTitle: title)
      lastItem?.representedObject = value
   }
}
#endif
