//
//  AudioUnitSettings.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 24.03.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import AudioUnit

public struct AudioUnitSettings {

   public enum Scope {
      case global
      case input
      case output
      fileprivate var value: UInt32 {
         switch self {
         case .global: return kAudioUnitScope_Global
         case .input: return kAudioUnitScope_Input
         case .output: return kAudioUnitScope_Output
         }
      }
   }

   public enum Error: Swift.Error {
      case OSStatusError(OSStatus)
      case unexpectedDataSize(expected: UInt32, observed: UInt32)
   }

   public static func setProperty<T>(for unit: AudioUnit, propertyID: AudioUnitPropertyID, scope: Scope,
                                     element: AudioUnitElement, data: T) throws {
      var value = data
      let dataSize = UInt32(MemoryLayout<T>.size)
      let status = AudioUnitSetProperty(unit, propertyID, scope.value, element, &value, dataSize)
      if status != noErr {
         throw Error.OSStatusError(status)
      }
   }

   public static func getPropertyInfo(for unit: AudioUnit, propertyID: AudioUnitPropertyID, scope: Scope,
                                      element: AudioUnitElement) throws -> (dataSize: UInt32, isWritable: Bool) {
      var dataSize: UInt32 = 0
      var isWritable = DarwinBoolean(false)
      let status = AudioUnitGetPropertyInfo(unit, propertyID, scope.value, element, &dataSize, &isWritable)
      if status != noErr {
         throw Error.OSStatusError(status)
      }
      return (dataSize, isWritable.boolValue)
   }

   public static func getProperty<T>(for unit: AudioUnit, propertyID: AudioUnitPropertyID, scope: Scope,
                                     element: AudioUnitElement) throws -> T {
      let propertyInfo = try getPropertyInfo(for: unit, propertyID: propertyID, scope: scope, element: element)
      let expectedDataSize = UInt32(MemoryLayout<T>.size)
      if expectedDataSize != propertyInfo.dataSize {
         throw Error.unexpectedDataSize(expected: expectedDataSize, observed: propertyInfo.dataSize)
      }
      var resultValue: T
      do {
         let data = UnsafeMutablePointer<T>.allocate(capacity: 1)
         defer {
            data.deallocate()
         }
         var dataSize = expectedDataSize
         let status = AudioUnitGetProperty(unit, propertyID, scope.value, element, data, &dataSize)
         if status != noErr {
            throw Error.OSStatusError(status)
         }
         if dataSize != expectedDataSize {
            throw Error.unexpectedDataSize(expected: expectedDataSize, observed: dataSize)
         }
         resultValue = data.pointee
      }

      return resultValue
   }

   public static func getParameter(for unit: AudioUnit, parameterID: AudioUnitParameterID, scope: Scope,
                                   element: AudioUnitElement) throws -> Float32 {
      var value: Float32 = 0
      let status = AudioUnitGetParameter(unit, parameterID, scope.value, element, &value)
      if status != noErr {
         throw Error.OSStatusError(status)
      }
      return value
   }
}
