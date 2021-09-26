//
//  Abort.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 27.09.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

public enum Abort {

   public static func notImplemented(file: StaticString = #file, line: UInt = #line) -> Never {
      return fatalError("Not implemented", file: file, line: line)
   }
}
