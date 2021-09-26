//
//  StringHash.swift
//  Playgrounds
//
//  Created by Vlad Gorlov on 15.06.20.
//

import Foundation

// See also:
// - http://www.cse.yorku.ca/~oz/hash.html
// - https://stackoverflow.com/questions/52440502/string-hashvalue-not-unique-after-reset-app-when-build-in-xcode-10
public class StringHash {

   public let string: String

   public private(set) lazy var djb2Hash = djb2HashValue()
   public private(set) lazy var sdbmHash = sdbmHashValue()

   public init(string: String) {
      self.string = string
   }

   func djb2HashValue() -> Int {
      let unicodeScalars = string.unicodeScalars.map { $0.value }
      return unicodeScalars.reduce(5381) {
         ($0 << 5) &+ $0 &+ Int($1)
      }
   }

   func sdbmHashValue() -> Int {
      let unicodeScalars = string.unicodeScalars.map { $0.value }
      return unicodeScalars.reduce(0) {
         (Int($1) &+ ($0 << 6) &+ ($0 << 16)).addingReportingOverflow(-$0).partialValue
      }
   }
}
