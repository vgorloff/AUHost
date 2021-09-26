//
//  Data.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcxTypes

public class _DataAsString: InstanceHolder<Data> {

   public enum Error: Swift.Error {
      case unableToEncodeToStringUsingEncoding(String.Encoding)
   }

   public func string(using encoding: String.Encoding) -> String? {
      return String(data: instance, encoding: encoding)
   }

   public func throwingString(using encoding: String.Encoding) throws -> String {
      if let value = string(using: encoding) {
         return value
      } else {
         throw Error.unableToEncodeToStringUsingEncoding(encoding)
      }
   }

   public var hexString: String {
      return instance.map { String(format: "%02.2hhx", $0) }.reduce("") { $0 + $1 }
   }
}

extension Data {

   public var asString: _DataAsString {
      return _DataAsString(instance: self)
   }
}

extension Data {

   public mutating func append(_ string: String) {
      if let data = string.data(using: .utf8) {
         append(data)
      }
   }
}
