//
//  OperatingSystemVersion.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 28.07.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

extension OperatingSystemVersion {

   public init(majorVersion: Int) {
      self.init(majorVersion: majorVersion, minorVersion: 0, patchVersion: 0)
   }

   public init(majorVersion: Int, minorVersion: Int) {
      self.init(majorVersion: majorVersion, minorVersion: minorVersion, patchVersion: 0)
   }

   public init?(string: String) {
      let components = string.components(separatedBy: ".").compactMap { Int($0) }
      if components.count == 1 {
         self = OperatingSystemVersion(majorVersion: components[0])
      } else if components.count == 2 {
         self = OperatingSystemVersion(majorVersion: components[0], minorVersion: components[1])
      } else if components.count == 3 {
         self = OperatingSystemVersion(majorVersion: components[0], minorVersion: components[1], patchVersion: components[2])
      } else {
         return nil
      }
   }

   public func string(separator: String) -> String {
      return "\(majorVersion)\(separator)\(minorVersion)\(separator)\(patchVersion)"
   }
}

extension OperatingSystemVersion: Comparable {

   public static func < (lhs: OperatingSystemVersion, rhs: OperatingSystemVersion) -> Bool {
      if lhs.majorVersion != rhs.majorVersion {
         return lhs.majorVersion < rhs.majorVersion
      }

      if lhs.minorVersion != rhs.minorVersion {
         return lhs.minorVersion < rhs.minorVersion
      }

      return lhs.patchVersion < rhs.patchVersion
   }

   public static func == (lhs: OperatingSystemVersion, rhs: OperatingSystemVersion) -> Bool {
      return lhs.majorVersion == rhs.majorVersion
         && lhs.minorVersion == rhs.minorVersion
         && lhs.patchVersion == rhs.patchVersion
   }
}
