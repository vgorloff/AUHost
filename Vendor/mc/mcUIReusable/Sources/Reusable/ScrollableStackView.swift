//
//  ScrollableStackView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import Foundation
import mcUI
import UIKit

public class ScrollableStackView<T: UIView>: View {

   private lazy var stackView = StackView().autolayoutView()
   public private(set) lazy var scrollView = ScrollView(frame: .zero).autolayoutView()

   public var orientation: NSLayoutConstraint.Axis {
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

   public init(orientation: NSLayoutConstraint.Axis) {
      super.init(frame: .zero)
      stackView.axis = orientation
      initialize()
   }

   public required init?(coder aDecoder: NSCoder) {
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
      scrollView.addSubview(stackView)
      anchor.pin.toBounds(scrollView).activate()
      switch orientation {
      case .horizontal:
         anchor.pin.vertically(stackView).activate()
         stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).activate()
         stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).activate(priority: .required - 1)
         anchor.equalHeight(viewA: stackView, viewB: self).activate()
      case .vertical:
         anchor.pin.horizontally(stackView).activate()
         stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).activate()
         stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).activate(priority: .required - 1)
         anchor.equalWidth(viewA: stackView, viewB: self).activate()
      @unknown default:
         assertionFailure("Unknown value: \"\(orientation)\". Please update \(#file)")
      }
   }
}
#endif
