//
//  AUNetStatus.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 04.04.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
#if os(macOS)
import AudioToolbox

public enum AUNetStatus: String {

   case notConnected, connected, overflow, underflow, connecting, listening

   public init?(auNetStatus: Int) {
      switch auNetStatus {
      case kAUNetStatus_NotConnected:
         self = .notConnected
      case kAUNetStatus_Connected:
         self = .connected
      case kAUNetStatus_Overflow:
         self = .overflow
      case kAUNetStatus_Underflow:
         self = .underflow
      case kAUNetStatus_Connecting:
         self = .connecting
      case kAUNetStatus_Listening:
         self = .listening
      default:
         return nil
      }
   }

   public var auNetStatus: Int {
      switch self {
      case .notConnected:
         return kAUNetStatus_NotConnected
      case .connected:
         return kAUNetStatus_Connected
      case .overflow:
         return kAUNetStatus_Overflow
      case .underflow:
         return kAUNetStatus_Underflow
      case .connecting:
         return kAUNetStatus_Connecting
      case .listening:
         return kAUNetStatus_Listening
      }
   }

   public var title: String {
      switch self {
      case .notConnected:
         return "Not Connected"
      case .connected:
         return "Connected"
      case .overflow:
         return "Overflow"
      case .underflow:
         return "Underflow"
      case .connecting:
         return "Connecting"
      case .listening:
         return "Listening"
      }
   }
}
#endif
