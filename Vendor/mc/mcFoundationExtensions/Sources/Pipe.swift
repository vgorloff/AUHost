//
//  Pipe.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation

extension Pipe {

   // Warning: Do not use for large buffers.
   // See: https://stackoverflow.com/questions/36009175/curl-through-nstask-not-terminating-if-a-pipe-is-present
   public func readIntoString() -> String? {
      var result: String?
      let data = fileHandleForReading.readDataToEndOfFile()
      if !data.isEmpty, let string = String(data: data, encoding: .utf8) {
         result = string.trimmingCharacters(in: .newlines)
      }
      return result
   }
}
