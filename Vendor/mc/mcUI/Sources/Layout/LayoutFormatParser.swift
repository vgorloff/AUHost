//
//  LayoutFormatParser.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import CoreGraphics
import Foundation
import mcFoundationExtensions

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
         let matches = regex.asMatches.ranges(in: format)
         guard matches.count == 1, let range = matches.first?.first, let groupRange = matches.first?.last else {
            return nil
         }
         if let dimensionValue = Scanner.mc.scanCGFloat(format[groupRange]) {
            processedFormat.removeSubrange(range)
            return Result(format: processedFormat, dimension: CGFloat(dimensionValue))
         }
      } catch {
         fatalError(String(describing: error))
      }
      return nil
   }
}
