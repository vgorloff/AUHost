//
//  AccessibilityKey.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public protocol AccessibilityKey {
   var accessibilityKey: String { get }
}

extension RawRepresentable where Self: AccessibilityKey, Self.RawValue == String {
   public var accessibilityKey: String {
      return rawValue
   }
}

extension String: AccessibilityKey {
   public var accessibilityKey: String { return self }
}
