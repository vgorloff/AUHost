//
//  AggregatedError.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.05.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct AggregatedError: Swift.Error {

   public let errors: [Swift.Error]

   public init(errors: [Swift.Error]) {
      self.errors = errors
   }
}
