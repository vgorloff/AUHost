//
//  DateFormatter.swift
//  mcCore
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public extension DateFormatter {

   public static func string(from date: Date, dateFormat: String) -> String {
      let f = DateFormatter()
      f.dateFormat = dateFormat
      return f.string(from: date)
   }
}
