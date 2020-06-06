//
//  NSMutableParagraphStyle.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 11.02.19.
//  Copyright © 2019 Vlad Gorlov. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension NSMutableParagraphStyle {

   public convenience init(lineSpacing: CGFloat) {
      self.init()
      self.lineSpacing = lineSpacing
   }
}
