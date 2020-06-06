//
//  AttributedStringProperties.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03/02/2017.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

struct AttributedStringProperties {

   #if os(iOS) || os(tvOS) || os(watchOS)
   typealias Font = UIFont
   public typealias Color = UIColor
   #elseif os(OSX)
   typealias Font = NSFont
   public typealias Color = NSColor
   #endif

   var font: Font?
   var foregroundColor: Color?
   var underlineStyle: NSUnderlineStyle?

   init(font: Font, foregroundColor: Color? = nil) {
      self.font = font
      self.foregroundColor = foregroundColor
   }

   var attributes: [NSAttributedString.Key: Any] {
      var result = [NSAttributedString.Key: Any]()
      if let value = font {
         result[.font] = value
      }
      if let value = foregroundColor {
         result[.foregroundColor] = value
      }
      if let underlineStyle = underlineStyle {
         result[.underlineStyle] = underlineStyle.rawValue
      }
      return result
   }
}

extension NSAttributedString {

   convenience init(string: String, properties: AttributedStringProperties) {
      self.init(string: string, attributes: properties.attributes)
   }
}

extension NSMutableAttributedString {

   func setProperties(_ properties: AttributedStringProperties, at range: NSRange) {
      setAttributes(properties.attributes, range: range)
   }
}
