//
//  ScrollableStackView.AppKit.swift
//  Playgrounds
//
//  Created by Vlad Gorlov on 06.03.21.
//

import Foundation
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcxRuntime
import mcxUI

public class ScrollableStackView<T: NSView>: View {

   private lazy var stackView = StackView().autolayoutView()
   public private(set) lazy var scrollView = ScrollView(frame: .zero).autolayoutView()

   public var orientation: NSUserInterfaceLayoutOrientation {
      return stackView.axis
   }

   public var spacing: CGFloat {
      get {
         return stackView.spacing
      } set {
         stackView.spacing = newValue
      }
   }

   public var views: [T] {
      get {
         stackView.arrangedSubviews.compactMap { $0 as? T }
      } set {
         stackView.removeArrangedSubviews()
         stackView.addArrangedSubviews(newValue)
      }
   }

   public init(orientation: NSUserInterfaceLayoutOrientation) {
      super.init(frame: NSRect(dimension: 100))
      stackView.orientation = orientation
      initialize()
   }

   @available(*, unavailable)
   public required init?(coder decoder: NSCoder) {
      fatalError()
   }

   // MARK: - Public

   public func addArrangedSubviews(_ subviews: [T]) {
      stackView.addArrangedSubviews(subviews)
   }

   public func addArrangedSubviews(_ subviews: T...) {
      stackView.addArrangedSubviews(subviews)
   }

   public func setCustomSpacing(_ spacing: CGFloat, after: T) {
      stackView.setCustomSpacing(spacing, after: after)
   }

   public func removeArrangedSubviews() {
      stackView.removeArrangedSubviews()
   }

   // MARK: - Private

   private func initialize() {

      addSubview(scrollView)
      anchor.pin.toBounds(scrollView).activate()

      let clipView = ClipView(frame: frame)
      clipView.documentView = stackView
      clipView.translatesAutoresizingMaskIntoConstraints = true
      clipView.autoresizingMask = [.height, .width]
      clipView.setIsFlipped(true)
      scrollView.contentView = clipView

      stackView.frame = frame
      stackView.translatesAutoresizingMaskIntoConstraints = false

      switch orientation {
      case .horizontal:
         scrollView.hasHorizontalScroller = true
         anchor.pin.vertically(stackView).activate()
         stackView.leadingAnchor.constraint(equalTo: clipView.leadingAnchor).activate()
      // Below line seems not needed.
      // stackView.trailingAnchor.constraint(equalTo: clipView.trailingAnchor).activate(priority: .dragThatCannotResizeWindow)
      case .vertical:
         scrollView.hasVerticalScroller = true
         anchor.pin.horizontally(stackView).activate()
         stackView.topAnchor.constraint(equalTo: clipView.topAnchor).activate()
      // Below line seems not needed.
      // stackView.bottomAnchor.constraint(equalTo: clipView.bottomAnchor).activate(priority: .dragThatCannotResizeWindow)
      @unknown default:
         Assertion.unknown(orientation)
      }

      // Should be one of last lines. At least after `ClipView` setup.
      scrollView.drawsBackground = false
   }
}
#endif
