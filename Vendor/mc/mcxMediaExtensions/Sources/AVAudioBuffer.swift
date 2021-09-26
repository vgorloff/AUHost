//
//  AVAudioBuffer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 18.08.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import AVFoundation
import CoreAudio
import mcxFoundationTestability

extension AVAudioBuffer {

   public var audioBuffers: [AudioBuffer] {
      return UnsafeMutableAudioBufferListPointer(mutableAudioBufferList).audioBuffers
   }

   public func dump() {
      for (index, buffer) in audioBuffers.enumerated() {
         print("[\(index)]: \(buffer.mFloatArray)")
      }
   }

   @objc public func debugQuickLookObject() -> AnyObject? {
      return QuickLookProxy(self)
   }
}
