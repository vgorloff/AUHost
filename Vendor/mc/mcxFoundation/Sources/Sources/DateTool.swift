//
//  DateTool.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 02/01/2017.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct DateTool {

   private let date: Date

   public init(_ date: Date) {
      self.date = date
   }

   public func timeAgo(since date: Date) -> String {
      let units = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfYear, .month, .year])
      let components: DateComponents
      if self.date.timeIntervalSince1970 <= date.timeIntervalSince1970 {
         components = Calendar.current.dateComponents(units, from: self.date, to: date)
      } else {
         components = Calendar.current.dateComponents(units, from: date, to: self.date)
      }
      let result: String
      if let year = components.year, year >= 1 {
         result = String.localizedStringWithFormat(Strings.yearsAgo, year)
      } else if let month = components.month, month >= 1 {
         result = String.localizedStringWithFormat(Strings.monthsAgo, month)
      } else if let weekOfYear = components.weekOfYear, weekOfYear >= 1 {
         result = String.localizedStringWithFormat(Strings.weeksAgo, weekOfYear)
      } else if let day = components.day, day >= 1 {
         result = String.localizedStringWithFormat(Strings.daysAgo, day)
      } else if let hour = components.hour, hour >= 1 {
         result = String.localizedStringWithFormat(Strings.hoursAgo, hour)
      } else if let minute = components.minute, minute >= 1 {
         result = String.localizedStringWithFormat(Strings.minutesAgo, minute)
      } else if let second = components.second, second >= 3 {
         result = String.localizedStringWithFormat(Strings.secondsAgo, second)
      } else {
         result = Strings.justNow
      }
      return result
   }
}

extension DateTool {

   fileprivate class Strings {

      static let bundle = Bundle(for: Strings.self)

      // FIXME: make english as a default and copy Plurals.
      static let justNow = NSLocalizedString("Gerade eben", bundle: DateTool.Strings.bundle, comment: "Human readable date/time interval")

      static let yearsAgo = NSLocalizedString("Vor %d Jahren",
                                              bundle: DateTool.Strings.bundle, comment: "Human readable date/time interval")
      static let monthsAgo = NSLocalizedString("Vor %d Monaten",
                                               bundle: DateTool.Strings.bundle, comment: "Human readable date/time interval")
      static let weeksAgo = NSLocalizedString("Vor %d Wochen",
                                              bundle: DateTool.Strings.bundle, comment: "Human readable date/time interval")
      static let daysAgo = NSLocalizedString("Vor %d Tagen",
                                             bundle: DateTool.Strings.bundle, comment: "Human readable date/time interval")
      static let hoursAgo = NSLocalizedString("Vor %d Stunden",
                                              bundle: DateTool.Strings.bundle, comment: "Human readable date/time interval")
      static let minutesAgo = NSLocalizedString("Vor %d Minuten",
                                                bundle: DateTool.Strings.bundle, comment: "Human readable date/time interval")
      static let secondsAgo = NSLocalizedString("Vor %d Sekunden",
                                                bundle: DateTool.Strings.bundle, comment: "Human readable date/time interval")
   }
}
