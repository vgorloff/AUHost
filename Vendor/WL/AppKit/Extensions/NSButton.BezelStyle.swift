//
//  NSButton.BezelStyle.swift
//  Admin-iOS
//
//  Created by Vlad Gorlov on 26.07.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import AppKit

extension NSButton.BezelStyle: CustomStringConvertible {

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
      }
   }
}
