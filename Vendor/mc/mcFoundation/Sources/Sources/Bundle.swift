//
//  Bundle.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation

extension Bundle {

   public enum Error: Swift.Error {
      case missedURLForResource(resourceName: String, resourceExtension: String)
      case resourceFileIsNotFound(name: String, in: Bundle)
   }

   public enum Key: String {
      case CFBundleVersion = "CFBundleVersion"
      case CFBundleShortVersionString = "CFBundleShortVersionString"
   }

   // MARK: -

   public func object(forKey: Key) -> Any? {
      return object(forInfoDictionaryKey: forKey.rawValue)
   }

   public func urlForResource(resourceName: String, resourceExtension: String) throws -> URL {
      guard let url = url(forResource: resourceName, withExtension: resourceExtension) else {
         throw Error.missedURLForResource(resourceName: resourceName, resourceExtension: resourceExtension)
      }
      return url
   }

   public func url(forResourceNamed fileName: String) throws -> URL {
      let ext = fileName.asPath.extension
      let baseName = fileName.deletingPathExtension
      guard let value = url(forResource: baseName, withExtension: ext) else {
         throw Error.resourceFileIsNotFound(name: fileName, in: self)
      }
      return value
   }
}
