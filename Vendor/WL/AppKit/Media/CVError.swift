//
//  CVError.swift
//  mcBase-macOS
//
//  Created by Vlad Gorlov on 19.08.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import CoreVideo
import Foundation

public enum CVError: Swift.Error {

   case code(CVReturn)

   init?(code: CVReturn) {
      if code == kCVReturnSuccess {
         return nil
      } else {
         self = .code(code)
      }
   }
}
