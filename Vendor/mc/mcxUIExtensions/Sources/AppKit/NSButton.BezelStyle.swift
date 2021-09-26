//
//  NSButton.BezelStyle.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSButton.BezelStyle: CustomStringConvertible {

   public static let allStyles: [NSButton.BezelStyle] = [.texturedRounded,
                                                         .texturedSquare,
                                                         .smallSquare,
                                                         .shadowlessSquare,
                                                         .roundRect,
                                                         .roundedDisclosure,
                                                         .rounded,
                                                         .regularSquare,
                                                         .recessed,
                                                         .inline,
                                                         .helpButton,
                                                         .disclosure,
                                                         .circular]

   public var description: String {
      switch self {
      case .circular:
         return "circular"
      case .disclosure:
         return "disclosure"
      case .helpButton:
         return "helpButton"
      case .inline:
         return "inline"
      case .recessed:
         return "recessed"
      case .regularSquare:
         return "regularSquare"
      case .rounded:
         return "rounded"
      case .roundedDisclosure:
         return "roundedDisclosure"
      case .roundRect:
         return "roundRect"
      case .shadowlessSquare:
         return "shadowlessSquare"
      case .smallSquare:
         return "smallSquare"
      case .texturedRounded:
         return "texturedRounded"
      case .texturedSquare:
         return "texturedSquare"
      @unknown default:
         assertionFailure("Unknown value: \"\(self)\". Please update \(#file)")
         return "Unknown"
      }
   }
}
#endif
