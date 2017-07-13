//
//  NSNib.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08.07.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

#if os(OSX)
import AppKit

extension NSNib {

   public func instantiate(withOwner owner: Any?) -> [Any]? {
      var topLevelObjects: NSArray?
      guard instantiate(withOwner: owner, topLevelObjects: &topLevelObjects) else {
         return nil
      }
      return topLevelObjects as? [Any]
   }
}
#endif
