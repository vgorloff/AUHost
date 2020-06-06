//
//  URL.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 10.11.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

extension URL {

   public var isHTTP: Bool {
      return scheme == "http" || scheme == "https"
   }

   // Every element is a string in key=value format
   public static func requestQuery(fromParameters elements: [String]) -> String {
      if elements.count > 0 {
         return elements[1 ..< elements.count].reduce(elements[0]) { $0 + "&" + $1 }
      } else {
         return elements[0]
      }
   }

   public func relativePath(from base: URL) -> String? {
      // Original code written by Martin R. https://stackoverflow.com/a/48360631/78336
      // Ensure that both URLs represent files
      guard isFileURL, base.isFileURL else {
         return nil
      }

      // Ensure that it's absolute paths. Ignore relative paths.
      guard baseURL == nil, base.baseURL == nil else {
         return nil
      }

      // Remove/replace "." and "..", make paths absolute
      let destComponents = standardizedFileURL.pathComponents
      let baseComponents = base.standardizedFileURL.pathComponents

      // Find number of common path components
      var i = 0
      while i < destComponents.count, i < baseComponents.count, destComponents[i] == baseComponents[i] {
         i += 1
      }

      // Build relative path
      var relComponents = Array(repeating: "..", count: baseComponents.count - i)
      relComponents.append(contentsOf: destComponents[i...])
      return relComponents.joined(separator: "/")
   }
}
