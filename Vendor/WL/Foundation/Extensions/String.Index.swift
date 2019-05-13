//
//  String.Index.swift
//  WL
//
//  Created by Vlad Gorlov on 03.07.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import Foundation

extension String.Index {

   @available(*, deprecated, message: "Please don't use this property")
   public func shifting(by offset: Int) -> String.Index {
      let newOffset = utf16Offset(in: "") + offset
      let referenceString = String(repeating: " ", count: newOffset)
      let result = String.Index(utf16Offset: newOffset, in: referenceString)
      return result
   }

   public func shifting(by offset: Int, in string: String) -> String.Index {
      return String.Index(utf16Offset: utf16Offset(in: string) + offset, in: string)
   }
}
