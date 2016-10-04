//
//  NSApplication.swift
//  AUHost
//
//  Created by Vlad Gorlov on 15.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AppKit

extension NSApplication {
   var applicationDelegate: AppDelegate {
      if let d = delegate as? AppDelegate {
         return d
      }
      fatalError()
   }
}
