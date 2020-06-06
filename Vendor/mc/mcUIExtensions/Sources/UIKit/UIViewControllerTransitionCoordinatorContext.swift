//
//  UIViewControllerTransitionCoordinatorContext.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIViewControllerTransitionCoordinatorContext {

   public var viewControllerTo: UIViewController? {
      return viewController(forKey: .to)
   }

   public var viewControllerFrom: UIViewController? {
      return viewController(forKey: .from)
   }
}
#endif
