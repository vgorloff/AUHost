//
//  NavigationController.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 05.05.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcGraphicsExtensions
import mcRuntime
import mcTypes
import mcUI

// See also:
// - https://github.com/bfolder/BFNavigationController/blob/master/BFNavigationController/BFNavigationController.m
// - https://github.com/bfolder/BFNavigationController/blob/master/BFNavigationController/NSView%2BBFUtilities.m
public class NavigationController: NSViewController {

   public private(set) lazy var navigationBar = NavigationBar(frame: CGRect.w100h100)
   private var containerView = View(frame: CGRect.w100h100)
   private var stackView = StackView(axis: .vertical)

   public private(set) var viewControllers: [NSViewController] = []

   override open func loadView() {
      view = NSView()
      view.addSubview(stackView)
      stackView.spacing = 0
      containerView.wantsLayer = true // To fix erro `fromView.superview must be layer-backed for animations to take effect`
      anchor.pin.toBounds(stackView).activate()
      stackView.addArrangedSubviews(navigationBar, containerView)
      navigationBar.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1).activate()
      containerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1).activate()
      stackView.distribution = .fill
   }

   public init(rootViewController: NSViewController) {
      super.init(nibName: nil, bundle: nil)
      configure(pushedViewController: rootViewController)
      rootViewController.navigationItem.internalBackButtonIsHidden = true
      navigationBar.pushItem(rootViewController.navigationItem, animated: false)
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }
}

extension NavigationController {

   public var topViewController: NSViewController? {
      return viewControllers.last
   }

   public func pushAnimated(_ viewController: NSViewController) {
      pushViewControllerAnimated(viewController)
   }

   public func pushViewControllerAnimated(_ viewController: NSViewController) {
      pushViewController(viewController, animated: true)
   }

   public func pushViewController(_ viewController: NSViewController, animated: Bool) {
      guard let oldVC = topViewController else {
         Assertion.shouldNeverHappen()
         return
      }
      configure(pushedViewController: viewController)
      viewController.navigationItem.onBack.setHandler(self) {
         $0.popViewController(animated: true)
      }
      viewController.view.frame = oldVC.view.frame
      viewController.navigationItem.internalBackButtonTitle = oldVC.title
      navigationBar.pushItem(viewController.navigationItem, animated: animated)
      if animated {
         let endFrame = oldVC.view.frame
         viewController.view.frame = endFrame.offsetBy(dx: endFrame.width, dy: 0)
         viewController.view.alphaValue = 0.85
         NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            context.allowsImplicitAnimation = true
            context.timingFunction = .easeOut
            viewController.view.animator().frame = endFrame
            viewController.view.animator().alphaValue = 1
            oldVC.view.animator().alphaValue = 0.25
         }) {
            oldVC.view.alphaValue = 1
            oldVC.view.removeFromSuperview()
         }
      } else {
         oldVC.view.removeFromSuperview()
      }
   }

   public func popToViewController(_ viewController: NSViewController, animated: Bool) {
      guard let index = viewControllers.firstIndex(of: viewController) else {
         return
      }

      if index == viewControllers.count - 1 {
         return
      }

      if index == 0 {
         popToRootViewController(animated: animated)
         return
      }

      guard let topVC = topViewController else {
         Assertion.shouldNeverHappen()
         return
      }

      viewControllers = Array(viewControllers[0 ... index]) + [topVC]
      for child in children where !viewControllers.contains(child) {
         unembedChildViewController(child)
      }
      navigationBar.setItems(viewControllers.map { $0.navigationItem }, animated: false)
      popViewController(animated: animated)
   }

   public func popToRootViewController(animated: Bool) {
      guard viewControllers.count > 1 else {
         return
      }

      guard let rootVC = viewControllers.first, let topVC = topViewController else {
         Assertion.shouldNeverHappen()
         return
      }
      viewControllers = [rootVC, topVC]
      for child in children where !viewControllers.contains(child) {
         unembedChildViewController(child)
      }
      navigationBar.setItems(viewControllers.map { $0.navigationItem }, animated: false)
      popViewController(animated: animated)
   }

   @discardableResult
   public func popViewControllerAnimated() -> NSViewController? {
      return popViewController(animated: true)
   }

   @discardableResult
   public func popViewController(animated: Bool) -> NSViewController? {
      guard viewControllers.count > 1 else {
         return nil
      }
      guard let oldVC = viewControllers.popLast() else {
         Assertion.shouldNeverHappen()
         return nil
      }
      guard let newVC = topViewController else {
         Assertion.shouldNeverHappen()
         return nil
      }

      view.addSubview(newVC.view, positioned: .below, relativeTo: oldVC.view)
      newVC.view.frame = oldVC.view.frame
      navigationBar.popItem(animated: animated)
      if animated {
         let endFrame = oldVC.view.frame.offsetBy(dx: oldVC.view.frame.width, dy: 0)
         NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.23
            context.allowsImplicitAnimation = true
            context.timingFunction = .easeIn
            oldVC.view.animator().frame = endFrame
            oldVC.view.animator().alphaValue = 0.85
         }) {
            self.unembedChildViewController(oldVC)
         }
      } else {
         unembedChildViewController(oldVC)
      }
      return oldVC
   }

   private func configure(pushedViewController viewController: NSViewController) {
      viewController.navigationController = self
      viewController.view.wantsLayer = true
      embedChildViewController(viewController, container: containerView)
      viewControllers.append(viewController)
   }
}

extension NSViewController {

   private struct OBJCAssociationKey {
      static var navigationController = "com.mc.navigationController"
      static var navigationItem = "com.mc.navigationItem"
   }

   public var navigationController: NavigationController? {
      get {
         return ObjCAssociation.value(from: self, forKey: &OBJCAssociationKey.navigationController)
      } set {
         ObjCAssociation.setAssign(value: newValue, to: self, forKey: &OBJCAssociationKey.navigationController)
      }
   }

   public var navigationItem: NavigationItem {
      if let item = _navigationItem {
         return item
      } else {
         let item = NavigationItem()
         _navigationItem = item
         return item
      }
   }

   private var _navigationItem: NavigationItem? {
      get {
         return ObjCAssociation.value(from: self, forKey: &OBJCAssociationKey.navigationItem)
      } set {
         ObjCAssociation.setRetainNonAtomic(value: newValue, to: self, forKey: &OBJCAssociationKey.navigationItem)
      }
   }
}
#endif
