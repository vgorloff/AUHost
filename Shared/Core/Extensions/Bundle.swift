//
//  Bundle.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public enum BundleError: Error {
   case missedURLForResource(resourceName: String, resourceExtension: String)
}

public extension Bundle {

   public func urlForResource(resourceName: String, resourceExtension: String) throws -> URL {
      guard let url = url(forResource: resourceName, withExtension: resourceExtension) else {
         throw BundleError.missedURLForResource(resourceName: resourceName, resourceExtension: resourceExtension)
      }
      return url
   }
}
