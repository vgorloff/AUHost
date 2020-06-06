//
//  ActionsBar.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 14.10.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import Foundation
import mcUI
import mcUIExtensions

public class ActionsBar: View {

   public private(set) var leftItems: [NSView] = []
   public private(set) var rightItems: [NSView] = []

   private lazy var containerView = View().autolayoutView()
   private lazy var leftItemsStackView = StackView().autolayoutView()
   private lazy var rightItemsStackView = StackView().autolayoutView()
   private lazy var edgesConstraint = ConstraintsSet.AllEdges(view: containerView, container: self)
   private lazy var stackViewsSpacing: NSLayoutConstraint
      = rightItemsStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leftItemsStackView.trailingAnchor)

   public var itemsSpacing: CGFloat = 8 {
      didSet {
         updateSpacing()
      }
   }

   public var edgeInsets = NSEdgeInsets(dimension: 8) {
      didSet {
         edgesConstraint.configure(insets: edgeInsets)
      }
   }
}

extension ActionsBar {

   public var leftItem: NSView? {
      return leftItems.first
   }

   public var rightItem: NSView? {
      return rightItems.first
   }

   public func setLeftItems(_ items: NSView...) {
      setLeftItems(items)
   }

   public func setRightItems(_ items: NSView...) {
      setRightItems(items)
   }

   public func setLeftItems(_ items: [NSView]) {
      leftItemsStackView.removeViews()
      leftItemsStackView.addArrangedSubviews(items)
      leftItems = items
      updateLayout()
   }

   public func setRightItems(_ items: [NSView]) {
      rightItemsStackView.removeViews()
      rightItemsStackView.addArrangedSubviews(items)
      rightItems = items
      updateLayout()
   }

   public func clearRightItems() {
      setRightItems([])
   }

   public func clearLeftItems() {
      setLeftItems([])
   }

   public func setLeftItem(_ item: NSView) {
      setLeftItems([item])
   }

   public func setRightItem(_ item: NSView) {
      setRightItems([item])
   }

   public func addLeftItem(_ item: NSView) {
      leftItems.append(item)
      leftItemsStackView.addArrangedSubview(item)
      updateLayout()
   }

   public func addRightItem(_ item: NSView) {
      rightItems.append(item)
      rightItemsStackView.addArrangedSubview(item)
      updateLayout()
   }
}

extension ActionsBar {

   override public func setupDefaults() {
      updateSpacing()
      edgesConstraint.configure(insets: edgeInsets)
   }

   override public func setupUI() {
      addSubview(containerView)

      containerView.addSubviews(leftItemsStackView, rightItemsStackView)
      leftItemsStackView.distribution = .fillProportionally
      rightItemsStackView.distribution = .fillProportionally
   }

   override public func setupLayout() {
      edgesConstraint.activate()
      stackViewsSpacing.activate()
      anchor.pinLeading(leftItemsStackView).activate()
      anchor.pinTrailing(rightItemsStackView).activate()
      anchor.pin(at: .vertically, leftItemsStackView, rightItemsStackView).activate()
   }

   private func updateSpacing() {
      leftItemsStackView.spacing = itemsSpacing
      rightItemsStackView.spacing = itemsSpacing
      updateLayout()
   }

   private func updateLayout() {
      let shouldUseSpacing = !leftItems.isEmpty && !rightItems.isEmpty
      stackViewsSpacing.constant = shouldUseSpacing ? itemsSpacing : 0
   }
}
#endif
