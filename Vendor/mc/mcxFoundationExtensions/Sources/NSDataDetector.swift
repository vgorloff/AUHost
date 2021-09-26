//
//  NSDataDetector.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

extension NSDataDetector {

   public convenience init(checkingTypes: NSTextCheckingResult.CheckingType) throws {
      try self.init(types: checkingTypes.rawValue)
   }
}
