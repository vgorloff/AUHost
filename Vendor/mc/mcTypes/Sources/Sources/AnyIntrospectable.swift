//
//  AnyIntrospectable.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public protocol AnyIntrospectable: CustomReflectable, CustomStringConvertible {
   var introspectionInfo: [String: Any] { get }
}

extension AnyIntrospectable {

   public var customMirror: Mirror {
      let c: [Mirror.Child] = introspectionInfo.map { ($0.key, $0.value) }
      return Mirror(self, children: c, ancestorRepresentation: .suppressed)
   }

   public var description: String {
      var options = JSONSerialization.WritingOptions.prettyPrinted
      if #available(OSX 10.13, iOS 11.0, watchOS 4.0, *) {
         options.insert(.sortedKeys)
      }
      do {
         let data = try JSONSerialization.data(withJSONObject: introspectionInfo, options: options)
         let result = String(data: data, encoding: .utf8) ?? "undefined"
         return result
      } catch {
         return "undefined"
      }
   }
}
