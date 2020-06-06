//
//  String+Base64.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension String {

   public var base64Encoded: String? {
      return data(using: .utf8)?.base64EncodedString()
   }

   public var base64Decoded: String? {
      guard let data = Data(base64Encoded: self) else {
         return nil
      }
      return String(data: data, encoding: .utf8)
   }
}
