//
//  RectEdge.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 22.07.19.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public struct RectEdgeAlias {
   #if os(iOS) || os(tvOS)
   public typealias RectEdge = UIRectEdge
   #elseif os(OSX)
   public typealias RectEdge = NSRectEdge
   #endif
}

extension RectEdgeAlias.RectEdge: Hashable {
}
