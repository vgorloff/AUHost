//
//  BuildInfo.swift
//  mcFoundation
//
//  Created by Volodymyr Gorlov on 09.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public enum BuildInfo {

   public static var isDebug: Bool {
      #if DEBUG // Do not forget to add DEBUG to Compiler Flags
      return true
      #else
      return false
      #endif
   }

   public static var isProduction: Bool {
      #if PRODUCTION // Do not forget to add PRODUCTION to Compiler Flags
      return true
      #else
      return false
      #endif
   }

   public static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

   public static var isAppStore: Bool {
      return isProduction && !isTestFlight
   }
}
