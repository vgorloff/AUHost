//
//  GLKMatrix4.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 10/10/2016.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation
#if !targetEnvironment(macCatalyst)
import GLKit
import simd

extension GLKMatrix4 {

   public var simdData: simd_float4x4 {
      let c0 = simd_float4(m.0, m.1, m.2, m.3)
      let c1 = simd_float4(m.4, m.5, m.6, m.7)
      let c2 = simd_float4(m.8, m.9, m.10, m.11)
      let c3 = simd_float4(m.12, m.13, m.14, m.15)
      return simd_float4x4(columns: (c0, c1, c2, c3))
   }

   public func data() -> [Float] {
      return [m.0, m.1, m.2, m.3, m.4, m.5, m.6, m.7, m.8, m.9, m.10, m.11, m.12, m.13, m.14, m.15]
   }
}
#endif
