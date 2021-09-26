//
//  Tmp.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 27.11.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

public enum Tmp {

   public static func make(prefix: String? = nil, suffix: String? = nil) -> String {
      var result = ""
      if let prefix = prefix {
         result += prefix + "-"
      }
      result += fileName
      if let suffix = suffix {
         result += "-" + suffix
      }
      return userDirectory.asPath.appendingComponent(result)
   }

   public static var userDirectory: String {
      return NSTemporaryDirectory()
   }

   public static var fileName: String {
      return ProcessInfo.processInfo.globallyUniqueString
   }
}
