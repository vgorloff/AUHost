//
//  UIView+Subviews.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import Foundation
import UIKit

extension UIView {

   public func subviews<T: UIView>(for type: T.Type) -> [T] {
      return subviews.compactMap { $0 as? T }
   }

   public func subview<T: UIView>(for type: T.Type) -> T? {
      return subviews(for: type).first
   }

   public func recursiveSubviews<T: UIView>(for type: T.Type) -> [T] {
      return recursiveSubviews.compactMap { $0 as? T }
   }

   public var recursiveSubviews: [UIView] {
      var result = subviews
      for subview in subviews {
         result += subview.recursiveSubviews
      }
      return result
   }

   public func recursiveSubview<ViewType: UIView,
                                TagType: RawRepresentable>(for type: ViewType.Type, tag: TagType) -> ViewType?
      where TagType.RawValue == Int {
      return recursiveSubviews(for: type).first(where: { $0.tag == tag.rawValue })
   }

   public func recursiveSubview<ViewType: UIView>(for type: ViewType.Type, accessibilityID: String) -> ViewType? {
      return recursiveSubviews(for: type).first(where: { $0.accessibilityIdentifier == accessibilityID })
   }

   public func addSubviews(_ views: UIView...) {
      for view in views {
         addSubview(view)
      }
   }

   public func addSubviews(_ views: [UIView]) {
      for view in views {
         addSubview(view)
      }
   }

   public func removeSubviews() {
      subviews.forEach { $0.removeFromSuperview() }
   }

   public func recursiveSubview<T: UIView>(for type: T.Type) -> T? {
      return recursiveSubviews(for: type).first
   }

   public func recursiveSubview<T: UIView>(for type: T.Type, tag: Int) -> T? {
      return recursiveSubviews(for: type).first(where: { $0.tag == tag })
   }

   public func recursiveSubviewWithTag(_ tag: Int) -> UIView? {
      return recursiveSubviews.first(where: { $0.tag == tag })
   }
}
#endif
