//
//  OSError.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 05.08.19.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import os

public enum OSError: Swift.Error {

   case code(OSStatus)

   public init?(code: OSStatus) {
      if code == noErr {
         return nil
      } else {
         self = .code(code)
      }
   }
}
