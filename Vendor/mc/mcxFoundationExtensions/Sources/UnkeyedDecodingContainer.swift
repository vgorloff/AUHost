//
//  UnkeyedDecodingContainer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 30.06.18.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension UnkeyedDecodingContainer {

   public mutating func decode<T>() throws -> T where T: Decodable {
      return try decode(T.self)
   }

   public mutating func decodeIfPresent<T>() throws -> T? where T: Decodable {
      return try decodeIfPresent(T.self)
   }

   public mutating func decodeArray<T>() throws -> [T] where T: Decodable {
      var list: [T] = []
      while !isAtEnd {
         list.append(try decode(T.self))
      }
      return list
   }
}
