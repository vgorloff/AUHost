//
//  StringRepresentable.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.02.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

public protocol StringRepresentable {
   var stringValue: String { get }
}

#if os(iOS)
extension CGRect: StringRepresentable {
   public var stringValue: String {
      return NSCoder.string(for: self)
   }
}

extension CGSize: StringRepresentable {
   public var stringValue: String {
      return NSCoder.string(for: self)
   }
}
#endif
