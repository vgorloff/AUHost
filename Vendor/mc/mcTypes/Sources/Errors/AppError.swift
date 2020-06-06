//
//  AppError.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 26.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public class AppError<T>: Swift.Error, LocalizedError, CustomStringConvertible {

   public let file: StaticString
   public let line: Int
   public let type: T

   public init(type: T, file: StaticString = #file, line: Int = #line) {
      self.type = type
      self.file = file
      self.line = line
   }

   public var description: String {
      return String(describing: type) + " at \(file):\(line)"
   }
}
