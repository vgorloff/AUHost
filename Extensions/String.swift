//
//  String.swift
//  WLCore
//
//  Created by Vlad Gorlov on 25.10.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

// NSString bindings
public extension String {

   public func stringByAppendingPathComponent(str: String) -> String {
      return (self as NSString).stringByAppendingPathComponent(str)
   }
   public var pathExtension: String {
      return (self as NSString).pathExtension
   }
   public var stringByDeletingPathExtension: String {
      return (self as NSString).stringByDeletingPathExtension
   }
   public func stringByAppendingPathExtension(str: String) -> String? {
      return (self as NSString).stringByAppendingPathExtension(str)
   }
   var lastPathComponent: String {
      return (self as NSString).lastPathComponent
   }
   var stringByDeletingLastPathComponent: String {
      return (self as NSString).stringByDeletingLastPathComponent
   }
   var stringByExpandingTildeInPath: String {
      return (self as NSString).stringByExpandingTildeInPath
   }
}


public extension String {
   public var uppercaseFirstCharacterString: String {
      if characters.count > 0 {
         let firstLetter = substringToIndex(startIndex.advancedBy(1)).capitalizedString
         let capitalisedSentence = substringFromIndex(startIndex.advancedBy(1))
         return firstLetter + capitalisedSentence
      } else {
         return self
      }
   }

	/// - parameter length: Desired string lenght. Should be at least 4 characters.
	/// - returns: New string by replacing original string middle characters with ".."
	public func clipToLength(length: Int) -> String {
		if length < 4 || characters.count < length {
			return self
		}

		let rangeEnd = length / 2 - 1 // "- 1" represents one dot "."
		let rangeStart = length - 2 - rangeEnd // "- 2" represents two dots ".."
		let range = startIndex.advancedBy(rangeStart) ..< endIndex.advancedBy(-rangeEnd)
		var s = self
		s.replaceRange(range, with: "..")
		return s
	}

	// swiftlint:disable variable_name
	public var OSTypeValue: OSType {
		let chars = utf8
		var result: UInt32 = 0
		for aChar in chars {
			result = result << 8 + UInt32(aChar)
		}
		return result
	}
	// swiftlint:enable variable_name

	public var componentsSeparatedByNewline: [String] {
		return componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
	}
}
