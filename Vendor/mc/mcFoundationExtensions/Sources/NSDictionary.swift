//
//  NSDictionary.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 30.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

extension NSDictionary {

   public func string(forKeyPath: String) -> String? {
      return value(forKeyPath: forKeyPath) as? String
   }

   public func int(forKeyPath: String) -> Int? {
      return value(forKeyPath: forKeyPath) as? Int
   }
}

extension NSDictionary {

   public func valueForRequiredKey<T>(_ key: String) throws -> T {
      guard let existingValue = value(forKey: key) else {
         throw DictionaryError.Key.requiredKeyIsMissed(key: key)
      }
      guard let resultValue = existingValue as? T else {
         throw DictionaryError.Key.requiredKeyHasWrongType(key: key, type: String(describing: type(of: existingValue)))
      }
      return resultValue
   }

   public func valueForOptionalKey<T>(_ key: String) -> T? {
      guard let existingValue = value(forKey: key) else {
         return nil
      }
      guard let resultValue = existingValue as? T else {
         return nil
      }
      return resultValue
   }
}
