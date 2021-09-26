//
//  UILabel.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UILabel {

   public func setAdjustsFontSizeToFitWidth(scaleFactor: CGFloat) {
      adjustsFontSizeToFitWidth = true
      minimumScaleFactor = scaleFactor
   }

   public convenience init(text: String) {
      self.init(frame: .zero)
      self.text = text
   }
}
#endif
