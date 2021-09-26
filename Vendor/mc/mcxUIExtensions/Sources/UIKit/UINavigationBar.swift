//
//  UINavigationBar.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UINavigationBar {

   public func setTransparent(_ shouldBeTransparent: Bool, for barMetrics: UIBarMetrics = .default) {
      if shouldBeTransparent {
         setBackgroundImage(UIImage(), for: barMetrics)
         shadowImage = UIImage()
      } else {
         setBackgroundImage(nil, for: barMetrics)
         shadowImage = nil
      }
   }
}
#endif
