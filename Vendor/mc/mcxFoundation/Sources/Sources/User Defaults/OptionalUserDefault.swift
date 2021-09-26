//
//  OptionalUserDefault.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

@propertyWrapper
public struct OptionalUserDefault<T> {
   public let key: SettingsKey

   public init(_ key: SettingsKey) {
      self.key = key
   }

   public var wrappedValue: T? {
      get {
         return UserDefaults.standard.value(forKey: key.id)
      } set {
         UserDefaults.standard.set(newValue, forKey: key.id)
      }
   }
}
