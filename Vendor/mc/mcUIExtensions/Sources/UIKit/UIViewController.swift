//
//  UIViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcUI
import UIKit

extension UIViewController {

   public static func initFromNib<T: UIViewController>(_: T.Type) -> T {
      let nibName = NSStringFromClass(T.self).components(separatedBy: ".").last ?? ""
      return T(nibName: nibName, bundle: Bundle(for: T.self))
   }

   public func child<T: UIViewController>(ofType: T.Type) -> T? {
      let matches = children.filter { $0 is T }
      guard let vc = matches.first as? T else {
         return nil
      }
      return vc
   }

   public func children<T: UIViewController>(ofType: T.Type) -> [T]? {
      let matches = children.filter { $0 is T }
      guard let controllers = matches as? [T], !matches.isEmpty else {
         return nil
      }
      return controllers
   }

   public func embedChild<T: UIViewController>(_ vc: T, container: UIView) {
      let controllers = children.filter { $0 is T }
      if !controllers.isEmpty {
         removeChild(type: T.self)
         assertionFailure()
      }
      addChild(vc)
      vc.view.translatesAutoresizingMaskIntoConstraints = false
      container.addSubview(vc.view)
      anchor.pin.toBounds(vc.view).activate()
      vc.didMove(toParent: self)
   }

   public func removeChild<T: UIViewController>(type: T.Type) {
      let controllers = children.filter { $0 is T }
      controllers.forEach {
         $0.willMove(toParent: nil)
         $0.view.removeFromSuperview()
         $0.removeFromParent()
      }
   }

   public func removeChildren(from container: UIView) {
      let controllers = children.filter { $0.view.superview == container }
      controllers.forEach {
         $0.willMove(toParent: nil)
         $0.view.removeFromSuperview()
         $0.removeFromParent()
      }
   }

   public func unembedFromParent() {
      willMove(toParent: nil)
      view.removeFromSuperview()
      removeFromParent()
   }

   public func presentAnimated(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
      if viewController.modalPresentationStyle == .popover, let popoverController = viewController.popoverPresentationController {
         if popoverController.sourceView == nil, popoverController.barButtonItem == nil {
            log.info(.controller, "Both `sourceView` and `barButtonItem` are nil. Presenting view controller at the center of the view.")
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
         }
      }
      present(viewController, animated: true, completion: completion)
   }

   public func dismissAnimated(completion: (() -> Void)? = nil) {
      dismiss(animated: true, completion: completion)
   }

   public func performSegueWithID(_ identifier: String, sender: Any? = nil) {
      performSegue(withIdentifier: identifier, sender: sender)
   }

   public func removeChild(_ childViewController: UIViewController) {
      childViewController.willMove(toParent: nil)
      childViewController.view.removeFromSuperview()
      childViewController.removeFromParent()
   }

   func removeChildren() {
      children.forEach { viewController in
         removeChild(viewController)
      }
   }

   public var anchor: LayoutConstraint {
      return LayoutConstraint()
   }
}
#endif
