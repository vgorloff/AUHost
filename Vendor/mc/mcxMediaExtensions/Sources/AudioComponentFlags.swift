//
//  AudioComponentFlags.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 10.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import AudioUnit

extension AudioComponentFlags: CustomReflectable {
   public var customMirror: Mirror {
      if #available(OSX 10.11, *) {
         let children: [Mirror.Child] = [("rawValue", rawValue),
                                         ("Unsearchable", contains(AudioComponentFlags.unsearchable)),
                                         ("SandboxSafe", contains(AudioComponentFlags.sandboxSafe)),
                                         ("RequiresAsyncInstantiation", contains(AudioComponentFlags.requiresAsyncInstantiation)),
                                         ("CanLoadInProcess", contains(AudioComponentFlags.canLoadInProcess))]
         return Mirror(self, children: children)
      } else {
         let children: [Mirror.Child] = [("rawValue", rawValue),
                                         ("Unsearchable", contains(AudioComponentFlags.unsearchable)),
                                         ("SandboxSafe", contains(AudioComponentFlags.sandboxSafe))]
         return Mirror(self, children: children)
      }
   }
}
