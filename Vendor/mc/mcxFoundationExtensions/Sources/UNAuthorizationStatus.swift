//
//  UNAuthorizationStatus.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 30.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcxRuntime
import UserNotifications

@available(macOS 10.14, *)
extension UNAuthorizationStatus: CustomStringConvertible {

   public var description: String {
      switch self {
      case .authorized:
         return "authorized"
      case .denied:
         return "denied"
      case .notDetermined:
         return "notDetermined"
      case .provisional:
         return "provisional"
      case .ephemeral:
         return "ephemeral"
      @unknown default:
         Assertion.unknown(self)
         return "unknown"
      }
   }
}
