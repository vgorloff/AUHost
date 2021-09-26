//
//  AppVersion.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

public enum AppVersion {

   public enum Style {
      case short
      case full(separator: String)
   }

   private static let bundleVersionString: String = {
      (Bundle.main.object(forKey: .CFBundleVersion) as? String) ?? ""
   }()

   public static let bundleVersion: Int = {
      let result = Int(bundleVersionString) ?? 0
      assert(result > 0)
      return result
   }()

   public static let shortVersion = version(style: .short)

   public static func version(style: Style) -> String {
      switch style {
      case .short:
         return (Bundle.main.object(forKey: .CFBundleShortVersionString) as? String) ?? ""
      case .full(let separator):
         return version(style: .short) + separator + bundleVersionString
      }
   }

   public static let fullVersion = version(style: .full(separator: "x"))
}
