//
//  Precondition.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 27.09.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct Precondition {

   static func ensure(_ condition: @autoclosure () -> Bool, file: StaticString = #file, line: UInt = #line) {
      precondition(condition(), file: file, line: line)
   }
}
