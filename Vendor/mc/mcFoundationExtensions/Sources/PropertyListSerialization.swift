//
//  PropertyListSerialization.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 14.10.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

extension PropertyListSerialization {

   enum Error: Swift.Error {
      case unexpectedType(expected: Any.Type, observed: Any.Type)
   }

   public static func dictionary(from url: URL) throws -> [AnyHashable: Any] {
      let data = try Data(contentsOf: url)
      return try dictionary(from: data)
   }

   public static func dictionary(from data: Data) throws -> [AnyHashable: Any] {
      let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
      guard let result = plist as? [AnyHashable: Any] else {
         throw Error.unexpectedType(expected: [AnyHashable: Any].self, observed: type(of: plist))
      }
      return result
   }
}
