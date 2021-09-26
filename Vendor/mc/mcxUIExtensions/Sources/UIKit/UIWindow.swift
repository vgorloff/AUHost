//
//  UIWindow.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 01.06.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit

extension UIWindow {

   // See also:
   // - https://stackoverflow.com/questions/41144523/swap-rootviewcontroller-with-animation
   func setRootViewControllerAnimated(_ viewController: UIViewController, animationDuration: TimeInterval = 0.3,
                                      shouldMakeWindowKey: Bool = true) {
      rootViewController = viewController
      if shouldMakeWindowKey {
         makeKeyAndVisible()
      }
      // Though `animations` is optional, the documentation tells us that it must not be nil.
      UIView.transition(with: self, duration: animationDuration,
                        options: .transitionCrossDissolve, animations: {}, completion: nil)
   }
}

#endif
