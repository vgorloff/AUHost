//
//  RangeReplaceableCollection.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 30.05.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

extension RangeReplaceableCollection where Iterator.Element: Equatable {

   public mutating func removeElement(_ object: Iterator.Element) {
      if let idx = firstIndex(of: object) {
         remove(at: idx)
      }
   }
}
