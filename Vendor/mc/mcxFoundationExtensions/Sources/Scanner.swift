//
//  Scanner.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08.11.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import CoreGraphics
import Foundation

extension Scanner {

   public var mc: MCAScanner {
      return MCAScanner(scanner: self)
   }
}

