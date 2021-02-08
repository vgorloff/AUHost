//
//  NSMutableAttributedString.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 24/02/2017.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import mcTypes

public class _NSMutableAttributedStringAsComposable: InstanceHolder<NSMutableAttributedString> {

   public func addAttribute(_ name: NSAttributedString.Key, value: Any, range: UTF16Range? = nil) {
      instance.addAttribute(name, value: value, range: range ?? instance.wholeStringRange)
   }

   public func setAttribute(_ name: NSAttributedString.Key, value: Any, range: UTF16Range? = nil) {
      instance.setAttributes([name: value], range: range ?? instance.wholeStringRange)
   }

   public func addParagraphStyle(_ paragraphStyle: NSParagraphStyle, range: UTF16Range? = nil) {
      addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
   }

   public func addFont(_ font: NSMutableAttributedString.Font, range: UTF16Range? = nil) {
      addAttribute(.font, value: font, range: range)
   }

   public func setFont(_ font: NSMutableAttributedString.Font, range: UTF16Range? = nil) {
      setAttribute(.font, value: font, range: range)
   }

   public func addForegroundColor(_ color: NSMutableAttributedString.Color, range: UTF16Range? = nil) {
      addAttribute(.foregroundColor, value: color, range: range)
   }

   public func addBackgroundColor(_ color: NSMutableAttributedString.Color, range: UTF16Range? = nil) {
      addAttribute(.backgroundColor, value: color, range: range)
   }

   public func addUnderlineStyle(_ style: NSUnderlineStyle, range: UTF16Range? = nil) {
      addAttribute(.underlineStyle, value: style.rawValue, range: range)
   }

   public func addUnderlineColor(_ color: NSMutableAttributedString.Color, range: UTF16Range? = nil) {
      addAttribute(.underlineColor, value: color, range: range)
   }

   public func append(_ string: String) {
      let str = NSAttributedString(string: string)
      instance.append(str)
   }

   public func append(_ string: String, font: NSMutableAttributedString.Font) {
      let str = NSAttributedString(string: string, attributes: [.font: font])
      instance.append(str)
   }
}

extension NSMutableAttributedString {

   #if os(iOS) || os(tvOS) || os(watchOS)
   public typealias Font = UIFont
   public typealias Color = UIColor
   #elseif os(OSX)
   public typealias Font = NSFont
   public typealias Color = NSColor
   #endif

   fileprivate var wholeStringRange: UTF16Range {
      return NSRange(location: 0, length: length)
   }

   public func replace(with: String) {
      replaceCharacters(in: wholeStringRange, with: with)
   }

   public func removeAttributes(range: UTF16Range? = nil) {
      setAttributes([:], range: range ?? wholeStringRange)
   }

   public var asComposable: _NSMutableAttributedStringAsComposable {
      return _NSMutableAttributedStringAsComposable(instance: self)
   }
}

extension NSMutableAttributedString {

   public func applyAttributesDelimitedBy(_ character: Character, _ attributes: [NSAttributedString.Key: Any]) {
      let ranges = string.range.rangesDelimitedBy(character: character)
      let nsRanges = ranges.map { NSRange($0, in: string) }
      nsRanges.forEach {
         addAttributes(attributes, range: $0)
      }
      // Removing delimiters
      var offset = 0
      for nsRange in nsRanges {
         replaceCharacters(in: NSRange(location: nsRange.location - offset - 1, length: 1), with: "")
         offset += 1
         replaceCharacters(in: NSRange(location: nsRange.upperBound - offset, length: 1), with: "")
         offset += 1
      }
   }
}
