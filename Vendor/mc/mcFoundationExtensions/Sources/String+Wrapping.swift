//
//  String+Wrapping.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 16.03.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension String {

   public var wraped: StringAsWrapping {
      return StringAsWrapping(payload: self)
   }
}

public struct StringAsWrapping {

   let payload: String

   init(payload: String) {
      self.payload = payload
   }

   public func with(_ string: String) -> String {
      return "\(string)\(payload)\(string)"
   }
}
