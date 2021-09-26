//
//  Bundle.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcxTypes

public enum BundleError: Swift.Error {
   case missedURLForResource(resourceName: String, resourceExtension: String)
   case resourceFileIsNotFound(name: String, in: Bundle)
}

public class __BundleURL: InstanceHolder<Bundle> {

   public func forResource(name: String, extension ext: String) throws -> URL {
      guard let url = instance.url(forResource: name, withExtension: ext) else {
         throw BundleError.missedURLForResource(resourceName: name, resourceExtension: ext)
      }
      return url
   }

   public func forResource(name: String) throws -> URL {
      let ext = name.asPath.extension
      let baseName = name.deletingPathExtension
      guard let value = instance.url(forResource: baseName, withExtension: ext) else {
         throw BundleError.resourceFileIsNotFound(name: name, in: instance)
      }
      return value
   }
}

extension Bundle {

   public enum Key: String {
      case CFBundleVersion = "CFBundleVersion"
      case CFBundleShortVersionString = "CFBundleShortVersionString"
   }

   // MARK: -

   public func object(forKey: Key) -> Any? {
      return object(forInfoDictionaryKey: forKey.rawValue)
   }

   public var url: __BundleURL {
      return __BundleURL(instance: self)
   }

   public func urlResource(name: String, subdirectory: String) -> URL? {
      let ext = name.asPath.extension
      let baseName = name.deletingPathExtension
      return url(forResource: baseName, withExtension: ext, subdirectory: subdirectory)
   }
}
