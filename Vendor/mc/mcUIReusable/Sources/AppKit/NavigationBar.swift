//
//  NavigationBar.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 01.06.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcUI
#if os(macOS)
import AppKit

open class NavigationBar: View {

   public var barTintColor: NSColor? {
      get {
         return backgroundColor
      } set {
         backgroundColor = newValue
      }
   }

   public private(set) var items: [NavigationItem] = []

   public var topItem: NavigationItem? {
      return items.last
   }

   public func pushItem(_ item: NavigationItem, animated: Bool) {
      items.append(item)
      if animated {
         let oldView = subviews.first
         let newView = item.view
         newView.frame = bounds.offsetBy(dx: bounds.width, dy: 0)
         addSubview(newView)
         newView.alphaValue = 0.85
         NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            context.allowsImplicitAnimation = true
            context.timingFunction = .easeOut
            newView.animator().frame = bounds
            newView.animator().alphaValue = 1
            oldView?.animator().alphaValue = 0
         }) {
            oldView?.removeFromSuperview()
            oldView?.alphaValue = 1
         }
      } else {
         showTopItem()
      }
   }

   @discardableResult
   public func popItem(animated: Bool) -> NavigationItem? {
      let item = items.popLast()
      if animated {
         let oldView = subviews.first
         let newView = topItem?.view
         newView?.frame = bounds
         newView?.alphaValue = 0
         if let newView = newView {
            addSubview(newView, positioned: .below, relativeTo: oldView)
         }
         let endFrame = bounds.offsetBy(dx: bounds.width, dy: 0)
         NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.23
            context.allowsImplicitAnimation = true
            context.timingFunction = .easeIn
            oldView?.animator().frame = endFrame
            oldView?.animator().alphaValue = 0
            newView?.alphaValue = 1
         }) {
            oldView?.removeFromSuperview()
            oldView?.alphaValue = 1
         }
      } else {
         showTopItem()
      }
      return item
   }

   public func setItems(_ items: [NavigationItem]?, animated: Bool) {
      self.items = items ?? []
      if animated {
         let oldView = subviews.first
         let newView = topItem?.view
         newView?.frame = bounds
         newView?.alphaValue = 0
         if let newView = newView {
            addSubview(newView, positioned: .below, relativeTo: oldView)
         }
         NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.23
            context.allowsImplicitAnimation = true
            context.timingFunction = .easeIn
            oldView?.animator().alphaValue = 0
            newView?.alphaValue = 1
         }) {
            oldView?.removeFromSuperview()
            oldView?.alphaValue = 1
         }
      } else {
         showTopItem()
      }
   }

   override open func setupLayout() {
      heightAnchor.constraint(equalToConstant: 36).activate()
   }

   private func showTopItem() {
      removeSubviews()
      if let topItemView = topItem?.view {
         topItemView.frame = bounds
         addSubview(topItemView)
      }
   }
}

#endif
