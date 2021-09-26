//
//  Locale.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 02.12.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

extension Locale {

   public struct CountryInfo: Equatable {
      public let isoCode: String
      public let displayName: String
   }

   public var counrtyInfos: [CountryInfo] {
      return Locale.counrtyInfos(for: self)
   }

   public static func counrtyInfos(for locale: Locale) -> [CountryInfo] {
      let nsLocale = locale as NSLocale
      let result: [CountryInfo] = NSLocale.isoCountryCodes.compactMap {
         if let displayName = nsLocale.displayName(forKey: .countryCode, value: $0) {
            return CountryInfo(isoCode: $0, displayName: displayName)
         } else {
            return nil
         }
      }
      // Seems `isoCountryCodes` already sorted. So, we skip sorting.
      return result
   }

   public var counrtyNames: [String] {
      return Locale.counrtyNames(for: self)
   }

   public static func counrtyNames(for locale: Locale) -> [String] {
      let nsLocale = locale as NSLocale
      let result: [String] = NSLocale.isoCountryCodes.compactMap {
         nsLocale.displayName(forKey: .countryCode, value: $0)
      }
      // Seems `isoCountryCodes` already sorted. So, we skip sorting.
      return result
   }

   public var is24HourDateFormat: Bool {
      // See more about `j`: http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
      guard let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: self) else {
         assertionFailure()
         return true
      }
      return !dateFormat.contains("a")
   }
}
