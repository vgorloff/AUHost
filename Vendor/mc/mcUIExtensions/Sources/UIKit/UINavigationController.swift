//
//  UINavigationController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UINavigationController {

   public var rootViewController: UIViewController? {
      get {
         return viewControllers.first
      } set {
         if let value = newValue {
            viewControllers = [value]
         } else {
            viewControllers = []
         }
      }
   }

   private func doAfterAnimatingTransition(animated: Bool, completion: (() -> Void)?) {
      guard let completion = completion else {
         return
      }
      if let coordinator = transitionCoordinator, animated {
         coordinator.animate(alongsideTransition: nil) { _ in
            completion()
         }
      } else {
         DispatchQueue.main.async {
            completion()
         }
      }
   }

   public func popAnimated(completion: (() -> Void)? = nil) {
      popViewController(animated: true, completion: completion)
   }

   public func pushAnimated(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
      pushViewController(viewController, animated: true, completion: completion)
   }

   public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
      pushViewController(viewController, animated: animated)
      doAfterAnimatingTransition(animated: animated, completion: completion)
   }

   public func popViewController(animated: Bool, completion: (() -> Void)?) {
      popViewController(animated: animated)
      doAfterAnimatingTransition(animated: animated, completion: completion)
   }

   public func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
      popToRootViewController(animated: animated)
      doAfterAnimatingTransition(animated: animated, completion: completion)
   }

   public func popToViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
      popToViewController(viewController, animated: animated)
      doAfterAnimatingTransition(animated: animated, completion: completion)
   }
}
#endif
