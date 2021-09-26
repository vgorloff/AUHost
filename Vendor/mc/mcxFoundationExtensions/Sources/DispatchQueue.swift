//
//  DispatchQueue.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation

extension DispatchQueue {

   public static var `default`: DispatchQueue {
      return DispatchQueue.global(qos: .default)
   }

   public static var userInteractive: DispatchQueue {
      return DispatchQueue.global(qos: .userInteractive)
   }

   public static var userInitiated: DispatchQueue {
      return DispatchQueue.global(qos: .userInitiated)
   }

   public static var utility: DispatchQueue {
      return DispatchQueue.global(qos: .utility)
   }

   public static var background: DispatchQueue {
      return DispatchQueue.global(qos: .background)
   }
}
