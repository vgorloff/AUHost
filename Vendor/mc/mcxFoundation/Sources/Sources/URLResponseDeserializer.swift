//
//  URLResponseDeserializer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 27.09.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct URLResponseDeserializer {

   public enum Error: LocalizedError, CustomStringConvertible {

      case unableConvertDataToJSON

      public var description: String {
         switch self {
         case .unableConvertDataToJSON:
            return NSLocalizedString("Unable to convert to JSON", comment: "Deserializer Error")
         }
      }

      public var errorDescription: String? {
         return description
      }
   }

   fileprivate let json: [AnyHashable: Any]

   public init(_ data: Data) throws {
      let JSON = try JSONSerialization.jsonObject(with: data, options: [])
      guard let dictionary = JSON as? [AnyHashable: Any] else {
         throw Error.unableConvertDataToJSON
      }
      json = dictionary
   }
}
