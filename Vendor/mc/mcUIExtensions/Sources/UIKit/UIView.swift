//
//  UIView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit) || targetEnvironment(macCatalyst)
import mcUI
import UIKit

extension UIView {

   public convenience init(backgroundColor: UIColor) {
      self.init(frame: CGRect())
      self.backgroundColor = backgroundColor
   }

   public static func instantiateFromNib<T: UIView>(withOwner: Any? = nil, options: [UINib.OptionsKey: Any]? = nil) -> T {
      let nibName = NSStringFromClass(T.self).components(separatedBy: ".").last ?? ""
      let nib = UINib(nibName: nibName, bundle: Bundle(for: T.self))
      let objects = nib.instantiate(withOwner: withOwner, options: options)
      for object in objects {
         if let view = object as? T {
            return view
         }
      }
      fatalError()
   }

   public var isVisible: Bool {
      get {
         return !isHidden
      } set {
         isHidden = !newValue
      }
   }

   public var anchor: LayoutConstraint {
      return LayoutConstraint()
   }
}

extension UIView {

   public func setBackgroundColor(_ color: UIColor, animationDuration: TimeInterval) {
      let temporaryView = UIView()
      temporaryView.backgroundColor = color
      temporaryView.alpha = 0

      insertSubview(temporaryView, at: 0)
      temporaryView.translatesAutoresizingMaskIntoConstraints = false
      leadingAnchor.constraint(equalTo: temporaryView.leadingAnchor).isActive = true
      trailingAnchor.constraint(equalTo: temporaryView.trailingAnchor).isActive = true
      topAnchor.constraint(equalTo: temporaryView.topAnchor).isActive = true
      bottomAnchor.constraint(equalTo: temporaryView.bottomAnchor).isActive = true

      UIView.animate(withDuration: animationDuration, animations: {
         temporaryView.alpha = 1.0
      }, completion: { _ in
         self.backgroundColor = color
         temporaryView.removeFromSuperview()
      })
   }

   public func setBorder(width: CGFloat, color: UIColor? = nil) {
      layer.setBorder(width: width, color: color)
   }

   public func setCornerRadius(_ radius: CGFloat) {
      layer.setCornerRadius(radius)
   }
}

extension UIView {

   public func mask(view: UIView, withRect rect: CGRect) {
      let maskLayer = CAShapeLayer()
      let path = CGPath(rect: rect, transform: nil)
      maskLayer.path = path
      view.layer.mask = maskLayer
   }
}

#endif
