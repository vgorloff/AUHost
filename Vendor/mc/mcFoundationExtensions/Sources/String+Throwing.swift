//
//  String+Throwing.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension String {

   public class Throwing {
      fileprivate let string: String
      fileprivate init(string: String) {
         self.string = string
      }
   }

   public var throwing: Throwing {
      return Throwing(string: self)
   }
}

extension String.Throwing {

   public enum Error: Swift.Error {
      case unableToEncodeToDataUsingEncoding(String.Encoding)
   }

   public func data(using: String.Encoding) throws -> Data {
      if let data = string.data(using: using) {
         return data
      } else {
         throw Error.unableToEncodeToDataUsingEncoding(using)
      }
   }
}
