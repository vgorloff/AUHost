//
//  NSSplitView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSSplitView {

   public func setProportionalPosition(_ proportion: CGFloat, ofDividerAt dividerIndex: Int) {
      let position = bounds.height * proportion
      setPosition(position, ofDividerAt: dividerIndex)
   }
}
#endif
