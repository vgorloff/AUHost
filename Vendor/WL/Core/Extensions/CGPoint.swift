//
//  CGPoint.swift
//  WLCore
//
//  Created by Vlad Gorlov on 02.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreGraphics

extension CGPoint: ValueHistoryType {
}

public func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
	return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}
