//
//  Result.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension Result {

   public typealias Completion = (Result<Success, Failure>) -> Void

   public var value: Success? {
      switch self {
      case .failure:
         return nil
      case .success(let result):
         return result
      }
   }
}
