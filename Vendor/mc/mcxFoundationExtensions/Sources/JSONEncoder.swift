//
//  JSONEncoder.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 14.10.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

extension JSONEncoder {

   public enum Error: Swift.Error {
      case unableToEncode
   }

   public func encodeJSON<T>(_ value: T) throws -> String where T: Encodable {
      let data = try encode(value)
      guard let string = String(data: data, encoding: .utf8) else {
         throw Error.unableToEncode
      }
      return string
   }
}
