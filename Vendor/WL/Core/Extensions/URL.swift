//
//  URL.swift
//  mcCore
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public extension URL {

   public var isHTTP: Bool {
      return scheme == "http" || scheme == "https"
   }

   // Every element is a string in key=value format
   public static func requestQuery(fromParameters elements: [String]) -> String {
      if elements.count > 0 {
         return elements[1 ..< elements.count].reduce(elements[0], { $0 + "&" + $1 })
      } else {
         return elements[0]
      }
   }
}
