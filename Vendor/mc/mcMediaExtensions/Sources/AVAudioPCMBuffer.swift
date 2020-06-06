//
//  AVAudioPCMBuffer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 18.08.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import AVFoundation
import mcFoundationTestability

extension AVAudioPCMBuffer {

   @objc override public func debugQuickLookObject() -> AnyObject? {
      return QuickLookProxy(self)
   }
}
