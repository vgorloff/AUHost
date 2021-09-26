//
//  BuildInfo.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public enum BuildInfo {

   public static var srcRootDirectory: String? // Set it in the `main.swift`.

   public static var isDebug: Bool {
      #if DEBUG // Do not forget to add DEBUG to Compiler Flags
      return true
      #else
      return false
      #endif
   }

   public static var isProduction = false // This value can be overridden in `main.swift` file. Usually it defined by `PRODUCTION` Compiler Flag.

   public static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

   public static var isAppStore: Bool {
      if isDebug {
         return false
      }
      if isTestFlight {
         return false
      }
      return isProduction
   }
}
