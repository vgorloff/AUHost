//
//  UNAuthorizationStatus.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 30.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcRuntime
import UserNotifications

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
      @unknown default:
         Assertion.unknown(self)
         return "unknown"
      }
   }
}
