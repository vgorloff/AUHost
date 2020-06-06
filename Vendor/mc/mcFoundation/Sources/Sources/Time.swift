//
//  Time.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 11/03/2017.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct Time {
   public struct Interval {
      public static let ThreeMinutes = TimeInterval(3 * 60)
      public static let FiveMinutes = TimeInterval(5 * 60)
      public static let OneHour = TimeInterval(60 * 60)
      public static let OneDay = OneHour * 24
      public static let OneWeek = OneDay * 7
      public static let ThirtyDays = OneDay * 30
   }
}
