//
//  Data.swift
//  mcCore
//
//  Created by Vlad Gorlov on 14/09/16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Foundation

extension Data {

   public var hexString: String {
      return map { String(format: "%02.2hhx", $0) }.reduce("", { $0 + $1 })
   }
}

extension Data {

   public mutating func append(_ string: String) {
      if let data = string.data(using: .utf8) {
         append(data)
      }
   }
}
