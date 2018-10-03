//
//  String.Index.swift
//  WL
//
//  Created by Vlad Gorlov on 03.07.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import Foundation

extension String.Index {

   public func shifting(by offset: Int) -> String.Index {
      return String.Index(encodedOffset: encodedOffset + offset)
   }
}
