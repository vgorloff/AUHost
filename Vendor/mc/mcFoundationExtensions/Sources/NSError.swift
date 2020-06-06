//
//  NSError.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 14/07/16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

extension NSError { struct Generic {} }
extension NSError.Generic {

   enum Types: Swift.Error {
      case unexpectedType(expected: Any.Type, observed: Any.Type)
   }
}

extension NSError { struct FileManager {} }
extension NSError.FileManager {

   enum IO: Swift.Error {
      case directoryIsNotAvailable(String)
      case regularFileIsNotAvailable(String)
      case canNotOpenFileAtPath(String)
      case executableNotFound(String)
   }
}
