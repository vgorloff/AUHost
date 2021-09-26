//
//  RegEx.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 12/11/2016.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

public class Regex {

   private let internalExpression: NSRegularExpression
   private let pattern: String

   public init(pattern: String, options: NSRegularExpression.Options = [.caseInsensitive]) throws {
      self.pattern = pattern
      internalExpression = try NSRegularExpression(pattern: pattern, options: options)
   }
}

extension Regex {

   public enum Pattern: String {
      case integers = "^([+-]?)(?:|0|[1-9]\\d*)?$"
      //   case decimals = "^([+-]?)(?:|0|[1-9]\\d*)(?:\\.\\d*)?$"
      case decimals = "^([0-9\\,\\.]*)$"
      //   case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
      case emailAlternative = "[A-Z0-9a-z._%+-=#!?{}$&*]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // FIXME: Decide and use only one pattern.
      case phone = "^([0-9\\(\\)\\/\\+\\-]*)$"

      public var predicate: NSPredicate {
         return NSPredicate(format: "SELF MATCHES %@", rawValue)
      }
   }
}
