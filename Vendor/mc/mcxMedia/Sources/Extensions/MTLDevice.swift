//
//  MTLDevice.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 11.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation
import MetalKit

@available(OSX 10.11, *)
extension MTLDevice {

   public var asThrowing: MTLDeviceAsThrowing {
      return MTLDeviceAsThrowing(instance: self)
   }
}

public struct MTLDeviceAsThrowing {

   public enum Error: Swift.Error {
      case unableToInitialize(AnyClass)
   }

   let instance: MTLDevice

   init(instance: MTLDevice) {
      self.instance = instance
   }

   public func makeBuffer(length: Int, options: MTLResourceOptions = []) throws -> MTLBuffer {
      guard let buffer = instance.makeBuffer(length: length, options: options) else {
         throw Error.unableToInitialize(MTLBuffer.self)
      }
      return buffer
   }

   /// Allocates a new buffer of a given length and initializes its contents by copying existing data into it.
   public func makeBuffer(bytes: UnsafeRawPointer, length: Int, options: MTLResourceOptions = []) throws -> MTLBuffer {
      guard let buffer = instance.makeBuffer(bytes: bytes, length: length, options: options) else {
         throw Error.unableToInitialize(MTLBuffer.self)
      }
      return buffer
   }
}
