//
//  AppId.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 27.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcRuntime

public class AppId {

   public static var shared = AppId()

   private let baseComponent: String
   private let separator = "-"
   private let keySeparator = "@"

   public init(id: String? = nil) {
      var baseComponent = id ?? Bundle.main.bundleIdentifier ?? "com.mc"
      baseComponent = baseComponent.replacingOccurrences(of: ".", with: separator)
      self.baseComponent = baseComponent
   }

   public private(set) lazy var id = RuntimeInfo.isUnderTesting ? "test-\(baseComponent)" : baseComponent

   public func make(group: String? = nil, key: String) -> String {
      if let group = group {
         return id + separator + group + keySeparator + key
      } else {
         return id + keySeparator + key
      }
   }

   public func make<T>(group: String? = nil, type: T.Type) -> String {
      var key = String(describing: type) // As alternative can be used `self.description()` or `NSStringFromClass(self)`
      key = key.components(separatedBy: ".").last ?? key
      return make(group: group, key: key)
   }
}
