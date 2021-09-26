//
//  NSPredicate.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 30.05.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

extension NSPredicate {

   public convenience init<T: Any>(block: @escaping (T) -> Bool) {
      self.init { object, _ in
         if let value = object as? T {
            return block(value)
         } else {
            return false
         }
      }
   }

   public static func emailValidationPredicate() -> NSPredicate {
      let regexPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,32}"
      return NSPredicate(format: "SELF MATCHES %@", regexPattern)
   }
}
