//
//  FontFamily.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 02.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public enum FontFamily: String {

   #if os(iOS) || os(tvOS) || os(watchOS)
   public typealias FontDescriptor = UIFontDescriptor
   public typealias Font = UIFont
   #elseif os(OSX)
   public typealias FontDescriptor = NSFontDescriptor
   public typealias Font = NSFont
   #endif

   case openSans = "Open Sans"
   case menlo = "Menlo"

   public func fontDescriptor(weight: Font.Weight) -> FontDescriptor {
      let attributes: [FontDescriptor.AttributeName: Any] = [.family: rawValue,
                                                             .traits: [FontDescriptor.TraitKey.weight: weight]]
      return FontDescriptor(fontAttributes: attributes)
   }
}
