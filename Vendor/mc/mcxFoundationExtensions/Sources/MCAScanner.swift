//
//  MCAScanner.swift
//  mc
//
//  Created by Vlad Gorlov on 05.05.21.
//

import Foundation
import CoreGraphics

public class MCAScanner {

   fileprivate let scanner: Scanner

   public init(scanner: Scanner) {
      self.scanner = scanner
   }
}

extension MCAScanner {

   public func scanUpToCharacters(from set: CharacterSet) -> String? {
      if #available(OSX 10.15, iOS 13.0, *) {
         return scanner.scanUpToCharacters(from: set)
      } else {
         var result: NSString?
         if scanner.scanUpToCharacters(from: set, into: &result), let value = result {
            return value as String
         } else {
            return nil
         }
      }
   }

   public func scanCharacters(from set: CharacterSet) -> String? {
      if #available(OSX 10.15, iOS 13.0, *) {
         return scanner.scanCharacters(from: set)
      } else {
         var result: NSString?
         if scanner.scanCharacters(from: set, into: &result), let value = result {
            return value as String
         } else {
            return nil
         }
      }
   }

   public func scanUpTo(string: String) -> String? {
      if #available(OSX 10.15, iOS 13.0, *) {
         return scanner.scanUpToString(string)
      } else {
         var result: NSString?
         if scanner.scanUpTo(string, into: &result), let value = result {
            return value as String
         } else {
            return nil
         }
      }
   }

   public func scanString(_ string: String) -> String? {
      if #available(OSX 10.15, iOS 13.0, *) {
         return scanner.scanString(string)
      } else {
         var result: NSString?
         if scanner.scanString(string, into: &result), let value = result {
            return value as String
         } else {
            return nil
         }
      }
   }

   public func scanDouble() -> Double? {
      if #available(OSX 10.15, iOS 13.0, *) {
         return scanner.scanDouble()
      } else {
         var value: Double = 0
         return scanner.scanDouble(&value) ? value : nil
      }
   }

   public func scanFloat() -> Float? {
      if #available(OSX 10.15, iOS 13.0, *) {
         return scanner.scanFloat()
      } else {
         var value: Float = 0
         return scanner.scanFloat(&value) ? value : nil
      }
   }

   public func scanCGFloat() -> CGFloat? {
      return scanFloat().map { CGFloat($0) }
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
