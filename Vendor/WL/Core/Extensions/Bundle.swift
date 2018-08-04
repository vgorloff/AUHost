//
//  Bundle.swift
//  mcCore
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

extension Bundle {

   public func urlForResource(resourceName: String, resourceExtension: String) throws -> URL {
      guard let url = url(forResource: resourceName, withExtension: resourceExtension) else {
         throw NSError.Bundle.missedURLForResource(resourceName: resourceName, resourceExtension: resourceExtension)
      }
      return url
   }
}

extension NSError {

   public enum Bundle: Swift.Error {
      case missedURLForResource(resourceName: String, resourceExtension: String)
   }
}
