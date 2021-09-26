//
//  UserDefaults.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation

extension UserDefaults {

   // MARK: -

   public func setDate(_ value: Date?, forKey key: String) {
      if let v = value {
         set(v, forKey: key)
      } else {
         removeObject(forKey: key)
      }
   }

   public func setString(_ value: String?, forKey key: String) {
      if let v = value {
         set(v, forKey: key)
      } else {
         removeObject(forKey: key)
      }
   }

   public func setBool(_ value: Bool?, forKey key: String) {
      if let v = value {
         set(v, forKey: key)
      } else {
         removeObject(forKey: key)
      }
   }

   public func setInteger(_ value: Int?, forKey key: String) {
      if let v = value {
         set(v, forKey: key)
      } else {
         removeObject(forKey: key)
      }
   }

   public func boolValue(key: String) -> Bool? {
      if object(forKey: key) != nil {
         return bool(forKey: key)
      } else {
         return nil
      }
   }

   public func integerValue(key: String) -> Int? {
      if object(forKey: key) != nil {
         return integer(forKey: key)
      } else {
         return nil
      }
   }

   public func dateValue(key: String) -> Date? {
      return object(forKey: key) as? Date
   }

   public func stringValue(key: String) -> String? {
      return string(forKey: key)
   }
}
