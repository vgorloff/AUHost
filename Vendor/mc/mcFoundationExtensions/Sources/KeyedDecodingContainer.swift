//
//  KeyedDecodingContainer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 30.06.18.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {

   public func decode<T>(key: K) throws -> T where T: Decodable {
      return try decode(T.self, forKey: key)
   }

   public func decodeIfPresent<T>(key: K) throws -> T? where T: Decodable {
      return try decodeIfPresent(T.self, forKey: key)
   }

   public func decodeIfPresent<T>(key: K, substitution: T) throws -> T where T: Decodable {
      return try decodeIfPresent(T.self, forKey: key) ?? substitution
   }
}
