//
//  NSString.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension NSString {

   public var characters: [unichar] {
      var result: [unichar] = []
      for index in 0 ..< length {
         result.append(character(at: index))
      }
      return result
   }
}
