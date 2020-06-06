//
//  Aliases.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#else
import UIKit
#endif

public struct __mcUIReusableAliases {
   #if canImport(AppKit) && !targetEnvironment(macCatalyst)
   public typealias View = NSView
   public typealias Color = NSColor
   #else
   public typealias View = UIView
   public typealias Color = UIColor
   #endif
}
