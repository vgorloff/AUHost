//
//  UserDefault.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefault<T> {
   public let key: SettingsKey
   public let defaultValue: T

   public init(_ key: SettingsKey, _ defaultValue: T) {
      self.key = key
      self.defaultValue = defaultValue
   }

   public var wrappedValue: T {
      get {
         return UserDefaults.standard.value(forKey: key.id) ?? defaultValue
      } set {
         UserDefaults.standard.set(newValue, forKey: key.id)
      }
   }
}
