//
//  LayoutFormatParser.swift
//  WL
//
//  Created by Vlad Gorlov on 02.06.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import CoreGraphics
import Foundation

struct LayoutFormatParser {

   struct Result {
      let format: String
      let dimension: CGFloat
   }

   private let format: String

   init(format: String) {
      self.format = format
   }

   func parseTop() -> Result? {
      if let result = parse(pattern: "^V:\\|-([\\d\\.]+)-") {
         return Result(format: "V:\(result.format)", dimension: result.dimension)
      }
      return nil
   }

   func parseBottom() -> Result? {
      return parse(pattern: "-([\\d\\.]+)-\\|$")
   }

   func parseLeading() -> Result? {
      return parse(pattern: "^\\|-([\\d\\.]+)-")
   }

   func parseTrailing() -> Result? {
      return parseBottom()
   }

   private func parse(pattern: String) -> Result? {
      do {
         var processedFormat = format
         let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
         let matches = regex.matches(in: format)
         guard matches.count == 1, let range = matches.first?.first, let groupRange = matches.first?.last else {
            return nil
         }
         if let dimensionValue = Scanner.scanCGFloat(format[groupRange]) {
            processedFormat.removeSubrange(range)
            return Result(format: processedFormat, dimension: CGFloat(dimensionValue))
         }
      } catch {
         fatalError(String(describing: error))
      }
      return nil
   }
}
