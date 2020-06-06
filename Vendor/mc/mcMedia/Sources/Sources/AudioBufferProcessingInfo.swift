//
//  AudioBufferProcessingInfo.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 19.03.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import AVFoundation
import CoreAudio

public struct AudioBufferProcessingInfo {

   public enum PointerType {
      case MutablePointer(UnsafeMutablePointer<AudioBufferList>)
      case NonMutablePointer(UnsafePointer<AudioBufferList>)
      case Both(UnsafePointer<AudioBufferList>, UnsafeMutablePointer<AudioBufferList>)
   }

   public var audioFormat: AVAudioFormat
   public var numberOfFrames: UInt32
   private var audioBufferList: PointerType

   public var audioBuffers: [AudioBuffer] {
      var abl: UnsafeMutablePointer<AudioBufferList>
      switch audioBufferList {
      case .MutablePointer(let p):
         abl = p
      case .NonMutablePointer(let p):
         abl = UnsafeMutablePointer<AudioBufferList>(mutating: p)
      case .Both(_, let p):
         abl = p
      }
      return UnsafeMutableAudioBufferListPointer(abl).audioBuffers
   }

   public init(audioFormat af: AVAudioFormat, audioBufferList abl: UnsafePointer<AudioBufferList>, numberOfFrames nof: UInt32) {
      audioFormat = af
      numberOfFrames = nof
      audioBufferList = .NonMutablePointer(abl)
   }

   public init(audioFormat af: AVAudioFormat,
               mutableAudioBufferList mabl: UnsafeMutablePointer<AudioBufferList>, numberOfFrames nof: UInt32) {
      audioFormat = af
      numberOfFrames = nof
      audioBufferList = .MutablePointer(mabl)
   }

   public init(audioPCMBuffer: AVAudioPCMBuffer) {
      audioFormat = audioPCMBuffer.format
      numberOfFrames = audioPCMBuffer.frameLength
      audioBufferList = .Both(audioPCMBuffer.audioBufferList, audioPCMBuffer.mutableAudioBufferList)
   }
}
