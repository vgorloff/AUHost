//
//  NSExceptionError.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct NSExceptionError: Swift.Error {

   public let exception: NSException

   public init(exception: NSException) {
      self.exception = exception
   }
}
