//
//  FileManager+Throwing.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcTypes

public class _FileManagerAsThrowing: InstanceHolder<FileManager> {

   public enum Error: Swift.Error {
      case unableToGetContentsOfFileAtPath(String)
   }

   public func contents(atPath path: String) throws -> Data {
      if let data = instance.contents(atPath: path) {
         return data
      } else {
         throw Error.unableToGetContentsOfFileAtPath(path)
      }
   }
}

extension FileManager {

   public var asThrowing: _FileManagerAsThrowing {
      return _FileManagerAsThrowing(instance: self)
   }
}
