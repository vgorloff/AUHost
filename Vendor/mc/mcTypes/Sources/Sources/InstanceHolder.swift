//
//  InstanceHolder.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 24.04.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

open class InstanceHolder<T> {

   public let instance: T

   public init(instance: T) {
      self.instance = instance
   }
}
