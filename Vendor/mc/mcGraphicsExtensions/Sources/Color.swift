//
//  Color.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public struct GraphicsExtensions {
   #if os(iOS) || os(tvOS) || os(watchOS)
   public typealias Color = UIColor
   #elseif os(OSX)
   public typealias Color = NSColor
   #endif
}

extension GraphicsExtensions.Color {

   public convenience init(hexValue hex: UInt64) {
      let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
      let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
      let blue = CGFloat(hex & 0xFF) / 255.0
      self.init(red: red, green: green, blue: blue, alpha: 1)
   }

   public convenience init?(hexString: String) {
      var string = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
      string = string.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
      guard string.count == 6 else {
         return nil
      }
      let scanner = Scanner(string: string)
      var hexNumber: UInt64 = 0
      if scanner.scanHexInt64(&hexNumber) {
         self.init(hexValue: hexNumber)
         return
      }
      return nil
   }
}
