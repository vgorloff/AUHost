//
//  LocalizedError.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 01.10.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

extension LocalizedError where Self: CustomStringConvertible {

   public var errorDescription: String? {
      return description
   }
}
