//
//  UserDefaults.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcFoundationObservables

extension UserDefaults {

   public func value<T>(forKey key: String) -> T? {
      if T.self == Int.self {
         return UserDefaults.standard.integer(forKey: key) as? T
      } else if T.self == Bool.self {
         return UserDefaults.standard.bool(forKey: key) as? T
      } else if T.self == String.self {
         return UserDefaults.standard.string(forKey: key) as? T
      } else {
         return UserDefaults.standard.object(forKey: key) as? T
      }
   }

   public func observe<T: Any>(key: String, callback: @escaping (T) -> Void) -> Observable {
      let result = KeyValueObserver<T>.observeNew(object: self, keyPath: key) {
         callback($0)
      }
      return result
   }

   public func observeString(key: String, callback: @escaping (String) -> Void) -> Observable {
      return observe(key: key, callback: callback)
   }
}
