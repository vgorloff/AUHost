//
//  AVAudioPCMBuffer.swift
//  WL
//
//  Created by Vlad Gorlov on 18.08.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import AVFoundation

extension AVAudioPCMBuffer {

   @objc public override func debugQuickLookObject() -> AnyObject? {
      return QuickLookProxy(self)
   }
}
