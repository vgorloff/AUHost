//
//  CGSize.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 17.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import CoreGraphics

#if os(iOS)
   extension CGSize: StringRepresentable {
      public var stringValue: String {
         return NSStringFromCGSize(self)
      }
   }
#endif
