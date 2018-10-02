//
//  Pipe.swift
//  mcCore
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

extension Pipe {

   func readIntoString() -> String? {
      var result: String?
      let data = fileHandleForReading.readDataToEndOfFile()
      if data.count > 0, let s = String(data: data, encoding: .utf8) {
         result = s.trimmingCharacters(in: .newlines)
      }
      return result
   }
}
