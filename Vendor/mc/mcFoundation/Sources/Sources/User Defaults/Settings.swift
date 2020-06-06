//
//  Settings.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 02.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcFoundationObservables
import mcRuntime

@propertyWrapper
public struct SettingsProperty<T> {
   public let defaultValue: T
   public let key: SettingsKey

   public init(_ key: String, _ group: String? = nil, _ defaultValue: T) {
      self.key = SettingsKey(key: key, group: group)
      self.defaultValue = defaultValue
   }

   public var wrappedValue: T {
      get {
         return UserDefaults.standard.value(forKey: key.id) ?? defaultValue
      } set {
         UserDefaults.standard.set(newValue, forKey: key.id)
      }
   }

   public var projectedValue: SettingsProperty<T> {
      return self
   }
}

open class Settings {

   private var observers: [Observable] = []

   public init() {
   }

   public func addObserver(forKey: SettingsKey, callback: @escaping () -> Void) {
      let observer = KeyValueObserver<Any>.observeNew(object: Settings.defaults, keyPath: forKey.id) { (_: Any) in
         callback()
      }
      observers.append(observer)
   }

   public func addObserver<Context: AnyObject>(_ caller: Context, forKey: SettingsKey, fireWithInitialValue: Bool = true,
                                               callback: @escaping (Context) -> Void) {
      let observer = KeyValueObserver<Any>.observeNew(object: Settings.defaults, keyPath: forKey.id) { [weak caller] (_: Any) in
         guard let caller = caller else { return }
         callback(caller)
      }
      observers.append(observer)
      if fireWithInitialValue {
         callback(caller)
      }
   }

   public func set(_ value: String?, forKey: SettingsKey, shouldNotify: Bool = true) {
      if shouldNotify {
         Settings.set(value, forKey: forKey)
      } else {
         observers.suspend()
         Settings.set(value, forKey: forKey)
         observers.resume()
      }
   }

   public func set(_ value: Bool, forKey: SettingsKey, shouldNotify: Bool = true) {
      if shouldNotify {
         Settings.set(value, forKey: forKey)
      } else {
         observers.suspend()
         Settings.set(value, forKey: forKey)
         observers.resume()
      }
   }
}

extension Settings {

   public static var defaults: UserDefaults {
      return UserDefaults.standard
   }

   public static func removeObject(forKey key: SettingsKey) {
      defaults.removeObject(forKey: key.id)
   }

   public static func set(_ newValue: String?, forKey key: SettingsKey) {
      defaults.set(newValue, forKey: key.id)
   }

   public static func string(forKey key: SettingsKey) -> String? {
      return defaults.string(forKey: key.id)
   }

   public static func set(_ newValue: URL?, forKey key: SettingsKey) {
      defaults.set(newValue, forKey: key.id)
   }

   public static func url(forKey key: SettingsKey) -> URL? {
      return defaults.url(forKey: key.id)
   }

   public static func set(_ newValue: Bool, forKey key: SettingsKey) {
      defaults.set(newValue, forKey: key.id)
   }

   public static func bool(forKey key: SettingsKey) -> Bool {
      return defaults.bool(forKey: key.id)
   }

   public static func set(_ newValue: Int?, forKey key: SettingsKey) {
      defaults.set(newValue, forKey: key.id)
   }

   public static func int(forKey key: SettingsKey) -> Int? {
      return defaults.object(forKey: key.id) as? Int
   }

   public static func set(_ newValue: Date?, forKey key: SettingsKey) {
      defaults.set(newValue, forKey: key.id)
   }

   public static func date(forKey key: SettingsKey) -> Date? {
      return defaults.object(forKey: key.id) as? Date
   }

   public static func set(_ newValue: Data?, forKey key: SettingsKey) {
      defaults.set(newValue, forKey: key.id)
   }

   public static func data(forKey key: SettingsKey) -> Data? {
      return defaults.data(forKey: key.id)
   }

   public static func set<T>(_ newValue: [T]?, forKey key: SettingsKey) {
      defaults.set(newValue, forKey: key.id)
   }

   public static func array<T>(forKey key: SettingsKey) -> [T]? {
      return defaults.value(forKey: key.id) as? [T]
   }
}
