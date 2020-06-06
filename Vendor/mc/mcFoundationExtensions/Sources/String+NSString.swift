//
//  String+NSString.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcTypes

extension String {

   public var asPath: Path {
      return Path(path: self)
   }

   public var asDir: Dir {
      return Dir(path: self)
   }
}

extension String {

   @available(swift, deprecated: 5.1, renamed: "asPath.extension")
   public var pathExtension: String {
      return asPath.extension
   }

   @available(swift, deprecated: 5.1, renamed: "asPath.deletingLastComponent()")
   public var deletingLastPathComponent: String {
      return asPath.deletingLastComponent()
   }

   @available(swift, deprecated: 5.1, renamed: "asPath.appendingComponent()")
   public func appendingPathComponent(_ str: String) -> String {
      return asPath.appendingComponent(str)
   }

   @available(swift, deprecated: 5.1, renamed: "asPath.appendingComponents()")
   public func appendingPathComponents(_ values: [String]) -> String {
      return asPath.appendingComponents(values)
   }

   public var deletingPathExtension: String {
      return (self as NSString).deletingPathExtension
   }

   public func appendingPathExtension(_ str: String) -> String? {
      return (self as NSString).appendingPathExtension(str)
   }

   public var pathComponents: [String] {
      return (self as NSString).pathComponents
   }

   public var lastPathComponent: String {
      return (self as NSString).lastPathComponent
   }

   public var expandingTildeInPath: String {
      return (self as NSString).expandingTildeInPath
   }

   public var abbreviatingWithTildeInPath: String {
      return (self as NSString).abbreviatingWithTildeInPath
   }

   public func replacingCharacters(in nsRange: NSRange, with: String) -> String {
      return (self as NSString).replacingCharacters(in: nsRange, with: with)
   }

   public func nsRange(of searchString: String) -> NSRange {
      return (self as NSString).range(of: searchString)
   }

   public func deletingLastPathComponents(_ numberOfComponents: Int) -> String {
      var result = self
      for _ in 0 ..< numberOfComponents {
         result = result.asPath.deletingLastComponent()
      }
      return result
   }
}
