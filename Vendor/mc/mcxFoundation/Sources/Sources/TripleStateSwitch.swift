//
//  TripleStateSwitch.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 11.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

public enum TripleStateSwitch: Int {

   case undefined = -1
   case on = 1
   case off = 0

   public init(fromBool: Bool) {
      self = fromBool ? .on : .off
   }

   public var boolValue: Bool {
      return self == .on ? true : false
   }
}
