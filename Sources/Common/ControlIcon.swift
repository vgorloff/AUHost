//
//  ControlIcon.swift
//  Attenuator
//
//  Created by Vlad Gorlov on 14.10.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import Foundation
import AppKit

enum ControlIcon {

   case library, play, pause, effect, reload

   var image: NSImage {
      let name: String
      switch self {
      case .library:
         name = "Control-Library"
      case .play:
         name = "Control-Play"
      case .pause:
         name = "Control-Pause"
      case .effect:
         name = "Control-Effect"
      case .reload:
         name = "Control-Reload"
      }
      guard let image = NSImage(named: name) else {
         fatalError()
      }
      return image
   }
}
