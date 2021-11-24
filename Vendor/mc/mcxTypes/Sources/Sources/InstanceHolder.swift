//
//  InstanceHolder.swift
//  MCA-OSS-VSTNS;MCA-OSS-AUH
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
