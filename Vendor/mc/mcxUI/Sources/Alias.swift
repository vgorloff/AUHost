//
//  Alias.swift
//  Decode
//
//  Created by Vlad Gorlov on 07.03.21.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public enum Alias {

   #if os(iOS) || os(tvOS) || os(watchOS)
   public typealias Color = UIColor
   #elseif os(OSX)
   public typealias Color = NSColor
   #endif
}
