//
//  UIStackView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIStackView {

   public convenience init(axis: NSLayoutConstraint.Axis, views: [UIView] = []) {
      self.init()
      self.axis = axis
      addArrangedSubviews(views)
   }

   public func addArrangedSubviews(_ subviews: UIView...) {
      addArrangedSubviews(subviews)
   }

   public func addArrangedSubviews(_ subviews: [UIView]) {
      subviews.forEach {
         addArrangedSubview($0)
      }
   }

   public func removeArrangedSubviews() {
      let views = arrangedSubviews
      views.forEach {
         removeArrangedSubview($0)
         // See why this is needed: https://medium.com/inloopx/uistackview-lessons-learned-e5841205f650
         $0.removeFromSuperview()
      }
   }

   public var edgeInsets: UIEdgeInsets {
      @available(*, unavailable)
      get {
         layoutMargins
      } set {
         isLayoutMarginsRelativeArrangement = true
         layoutMargins = newValue
      }
   }
}
#endif
