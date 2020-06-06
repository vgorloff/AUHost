//
//  SettingsKey.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 27.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcTypes

open class SettingsKey: ExpressibleByStringLiteral {

   public let key: String
   public let group: String?

   public required init(stringLiteral key: String) {
      self.key = key
      group = nil
   }

   public init(key: String, group: String? = nil) {
      self.key = key
      self.group = group
   }

   open var id: String {
      return AppId.shared.make(group: group, key: key)
   }
}
