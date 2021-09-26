//
//  NumberFormatter.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 04/05/16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import CoreGraphics
import Foundation

extension NumberFormatter {

   public func float(fromString stringOrNil: String?) -> Float? {
      if let value = stringOrNil {
         return number(from: value)?.floatValue
      }
      return nil
   }

   public func cgFloat(fromString stringOrNil: String?) -> CGFloat? {
      if let value = float(fromString: stringOrNil) {
         return CGFloat(value)
      }
      return nil
   }

   public func string(fromFloat valueOrNil: Float?) -> String? {
      if let value = valueOrNil {
         return string(from: NSNumber(value: value))
      }
      return nil
   }

   public func string(fromInt32 valueOrNil: Int32?) -> String? {
      if let value = valueOrNil {
         return string(from: NSNumber(value: value))
      }
      return nil
   }

   public func string(fromInt valueOrNil: Int?) -> String? {
      if let value = valueOrNil {
         return string(from: NSNumber(value: value))
      }
      return nil
   }
}
