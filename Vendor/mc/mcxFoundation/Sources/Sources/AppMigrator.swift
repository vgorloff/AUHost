//
//  AppMigrator.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 02.07.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

open class AppMigrator {

   private enum Key {
      static let bundleVersion: SettingsKey = "bundleVersion"
   }

   public class var bundleVersion: Int? {
      get {
         return Settings.int(forKey: Key.bundleVersion)
      } set {
         Settings.set(newValue, forKey: Key.bundleVersion)
      }
   }

   public typealias BundleVersion = Int

   public var current: BundleVersion {
      return AppVersion.bundleVersion
   }

   public var previous: BundleVersion {
      return type(of: self).bundleVersion ?? 0
   }

   public var isMigrationNeeded: Bool {
      return previous < current
   }

   public func performMigrationIfNeeded() {
      if isMigrationNeeded {
         performMigration(previous: previous, current: current)
         log.default(.service, "Will perform app migration from v.\(previous) to v.\(current)")
         type(of: self).bundleVersion = current
      }
   }

   open func performMigration(previous: BundleVersion, current: BundleVersion) {
      // Base class does nothing
   }
}
