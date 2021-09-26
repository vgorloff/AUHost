//
//  UIImageView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
#if !os(macOS)
import Foundation
import UIKit

extension UIImageView {

   public func startLoopAnimation(animationDuration: TimeInterval) {
      self.animationDuration = animationDuration
      animationRepeatCount = 0
      startAnimating()
   }
}
#endif
#endif
