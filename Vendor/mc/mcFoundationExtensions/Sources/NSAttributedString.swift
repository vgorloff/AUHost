//
//  NSAttributedString.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09.07.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

extension NSAttributedString {

   public var attributes: [(Range<String.Index>, [NSAttributedString.Key: Any])] {
      let nsRange = NSRange(location: 0, length: (string as NSString).length)
      var result: [(Range<String.Index>, [NSAttributedString.Key: Any])] = []
      enumerateAttributes(in: nsRange, options: []) { attributes, nsRange, _ in
         if let range = Range(nsRange, in: string) {
            result.append((range, attributes))
         } else {
            assert(false)
         }
      }
      return result
   }
}
