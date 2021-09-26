//
//  StringIndex.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 25.06.19.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public class StringIndex {

   public let string: String

   public init(string: String) {
      self.string = string
   }

   public var startIndex: String.Index {
      return string.startIndex
   }

   public var endIndex: String.Index {
      return string.endIndex
   }
}
