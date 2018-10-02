//
//  AVAudioBuffer.swift
//  WL
//
//  Created by Vlad Gorlov on 18.08.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import AVFoundation

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
