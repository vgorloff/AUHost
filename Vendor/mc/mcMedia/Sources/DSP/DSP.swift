//
//  DSP.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 29.05.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Accelerate

public struct DSP {

   public static func vsmul(inputVector: UnsafePointer<Float>, inputVectorStride: vDSP_Stride = 1,
                            inputScalar: Float, outputVector: UnsafeMutablePointer<Float>,
                            outputVectorStride: vDSP_Stride = 1, numberOfElements: vDSP_Length) {
      var inputScalarValue = inputScalar
      return vDSP_vsmul(inputVector, inputVectorStride, &inputScalarValue, outputVector, outputVectorStride, numberOfElements)
   }
}
