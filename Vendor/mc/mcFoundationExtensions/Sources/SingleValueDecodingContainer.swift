//
//  SingleValueDecodingContainer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 30.06.18.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension SingleValueDecodingContainer {
   public mutating func decode<T>() throws -> T where T: Decodable {
      return try decode(T.self)
   }
}
