//
//  Bundle.swift
//  mcCore
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

extension Bundle {

   enum Error: Swift.Error {
      case resourceFileIsNotFound(name: String, in: Bundle)
   }

   public func urlForResource(resourceName: String, resourceExtension: String) throws -> URL {
      guard let url = url(forResource: resourceName, withExtension: resourceExtension) else {
         throw NSError.Bundle.missedURLForResource(resourceName: resourceName, resourceExtension: resourceExtension)
      }
      return url
   }

   public func url(forResourceNamed fileName: String) throws -> URL {
      let ext = fileName.pathExtension
      let baseName = fileName.deletingPathExtension
      guard let value = url(forResource: baseName, withExtension: ext) else {
         throw Error.resourceFileIsNotFound(name: fileName, in: self)
      }
      return value
   }
}

extension NSError {

   public enum Bundle: Swift.Error {
      case missedURLForResource(resourceName: String, resourceExtension: String)
   }
}
