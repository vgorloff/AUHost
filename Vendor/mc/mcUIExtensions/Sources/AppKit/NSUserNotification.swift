//
//  NSUserNotification.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import Foundation

extension NSUserNotification.ActivationType: CustomStringConvertible {

   public var description: String {
      switch self {
      case .actionButtonClicked:
         return "actionButtonClicked"
      case .additionalActionClicked:
         return "additionalActionClicked"
      case .contentsClicked:
         return "contentsClicked"
      case .none:
         return "none"
      case .replied:
         return "replied"
      @unknown default:
         assertionFailure("Unknown value: \"\(self)\". Please update \(#file)")
         return "Unknown"
      }
   }
}
#endif
