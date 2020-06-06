//
//  Scanner.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08.11.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import CoreGraphics
import Foundation

extension Scanner {

   public class mc {

      fileprivate let scanner: Scanner

      public init(scanner: Scanner) {
         self.scanner = scanner
      }
   }

   public var mc: Scanner.mc {
      return Scanner.mc(scanner: self)
   }
}

extension Scanner.mc {

   public func scanUpToCharacters(from set: CharacterSet) -> String? {
      var result: NSString?
      if scanner.scanUpToCharacters(from: set, into: &result), let value = result {
         return value as String
      } else {
         return nil
      }
   }

   public func scanCharacters(from set: CharacterSet) -> String? {
      var result: NSString?
      if scanner.scanCharacters(from: set, into: &result), let value = result {
         return value as String
      } else {
         return nil
      }
   }

   public func scanUpTo(string: String) -> String? {
      var result: NSString?
      if scanner.scanUpTo(string, into: &result), let value = result {
         return value as String
      } else {
         return nil
      }
   }

   public func scanString(_ string: String) -> String? {
      var result: NSString?
      if scanner.scanString(string, into: &result), let value = result {
         return value as String
      } else {
         return nil
      }
   }

   public func scanDouble() -> Double? {
      var value: Double = 0
      return scanner.scanDouble(&value) ? value : nil
   }

   public func scanFloat() -> Float? {
      var value: Float = 0
      return scanner.scanFloat(&value) ? value : nil
   }

   public func scanCGFloat() -> CGFloat? {
      var value: Float = 0
      return scanner.scanFloat(&value) ? CGFloat(value) : nil
   }

   public func scanInt() -> Int? {
      var value: Int = 0
      return scanner.scanInt(&value) ? value : nil
   }

   public static func scanCGFloat(_ string: String) -> CGFloat? {
      return Scanner(string: string).mc.scanCGFloat()
   }

   public static func scanCGFloat(_ substring: Substring) -> CGFloat? {
      return Scanner(string: String(substring)).mc.scanCGFloat()
   }
}
