//
//  Date.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension Date {

   public init?(year: Int, month: Int, day: Int) {
      var components = DateComponents()
      components.year = year
      components.month = month
      components.day = day
      if let date = Calendar.current.date(from: components) {
         self = date
      } else {
         return nil
      }
   }
}

extension Date {

   public var isToday: Bool {
      return Calendar.current.isDateInToday(self)
   }

   public var isYesterday: Bool {
      return Calendar.current.isDateInYesterday(self)
   }

   public func isInSameDayOf(date: Date) -> Bool {
      return Calendar.current.isDate(self, inSameDayAs: date)
   }

   public func isBefore(date: Date, granularity: Calendar.Component) -> Bool {
      let result = Calendar.current.compare(self, to: date, toGranularity: granularity)
      return result == .orderedAscending
   }
}

extension Date {

   public func byAdding(years: Int) -> Date? {
      var dc = DateComponents()
      dc.year = years
      return Calendar.current.date(byAdding: dc, to: self)
   }

   public func byAdding(months: Int) -> Date? {
      var dc = DateComponents()
      dc.month = months
      return Calendar.current.date(byAdding: dc, to: self)
   }

   public func byAdding(weeksOfYear: Int) -> Date? {
      var dc = DateComponents()
      dc.weekOfYear = weeksOfYear
      return Calendar.current.date(byAdding: dc, to: self)
   }

   public func byAdding(days: Int) -> Date? {
      var dc = DateComponents()
      dc.day = days
      return Calendar.current.date(byAdding: dc, to: self)
   }

   public func byAdding(hours: Int) -> Date? {
      var dc = DateComponents()
      dc.hour = hours
      return Calendar.current.date(byAdding: dc, to: self)
   }

   public func byAdding(minutes: Int) -> Date? {
      var dc = DateComponents()
      dc.minute = minutes
      return Calendar.current.date(byAdding: dc, to: self)
   }

   public func byAdding(seconds: Int) -> Date? {
      var dc = DateComponents()
      dc.second = seconds
      return Calendar.current.date(byAdding: dc, to: self)
   }

   public func byAdding(nanoseconds: Int) -> Date? {
      var dc = DateComponents()
      dc.nanosecond = nanoseconds
      return Calendar.current.date(byAdding: dc, to: self)
   }
}

extension Date {

   public var year: Int {
      return Calendar.current.component(.year, from: self)
   }

   public var month: Int {
      return Calendar.current.component(.month, from: self)
   }

   public var day: Int {
      return Calendar.current.component(.day, from: self)
   }

   public var hour: Int {
      return Calendar.current.component(.hour, from: self)
   }

   public var minute: Int {
      return Calendar.current.component(.minute, from: self)
   }

   public var second: Int {
      return Calendar.current.component(.second, from: self)
   }
}
