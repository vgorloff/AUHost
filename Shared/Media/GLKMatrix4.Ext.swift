//
//  GLKMatrix4.Ext.swift
//  Attenuator
//
//  Created by VG (DE) on 10/10/2016.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Foundation
import GLKit

extension GLKMatrix4 {
   func data() -> [Float] {
      return [m.0, m.1, m.2, m.3, m.4, m.5, m.6, m.7, m.8, m.9, m.10, m.11, m.12, m.13, m.14, m.15]
   }
}
