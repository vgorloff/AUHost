//
//  JSONDecoder.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 30.06.18.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension JSONDecoder {

   public convenience init(dateDecodingStrategy: DateDecodingStrategy) {
      self.init()
      self.dateDecodingStrategy = dateDecodingStrategy
   }

   public func decode<T>(from data: Data) throws -> T where T: Decodable {
      return try decode(T.self, from: data)
   }

   public func decode<T>(_ type: T.Type, from json: [String: Any]) throws -> T where T: Decodable {
      let data = try JSONSerialization.data(withJSONObject: json, options: [])
      return try decode(type, from: data)
   }

   public func decode<T>(_ type: T.Type, from json: [AnyHashable: Any]) throws -> T where T: Decodable {
      let data = try JSONSerialization.data(withJSONObject: json, options: [])
      return try decode(type, from: data)
   }
}

extension JSONDecoder {

   public struct DecodingError<T>: Swift.Error {

      let type: T.Type
      let payload: Swift.Error

      public init(type: T.Type, payload: Swift.Error) {
         self.type = type
         self.payload = payload
      }
   }
}
