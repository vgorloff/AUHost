//
//  UIViewControllerContextTransitioning.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIViewControllerContextTransitioning {

   public var fromViewController: UIViewController? {
      return viewController(forKey: .from)
   }

   public var toViewController: UIViewController? {
      return viewController(forKey: .to)
   }

   public var fromView: UIView? {
      return view(forKey: .from)
   }

   public var toView: UIView? {
      return view(forKey: .to)
   }
}
#endif
