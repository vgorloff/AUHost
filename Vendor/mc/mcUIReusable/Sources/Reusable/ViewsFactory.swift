//
//  ViewsFactory.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit) || targetEnvironment(macCatalyst)
import mcFoundation
import mcUI
import mcUIExtensions
import UIKit

public struct ViewsFactory {

   public static var zeroHeight = CGFloat.leastNormalMagnitude

   public static func horizontalLine(height: CGFloat = 1 / UIScreen.main.scale, colour: UIColor) -> View {
      let view = View()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.backgroundColor = colour
      view.heightAnchor.constraint(equalToConstant: height).activate()
      return view
   }

   public static func verticalLine(width: CGFloat = 1 / UIScreen.main.scale, colour: UIColor) -> View {
      let view = View()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.backgroundColor = colour
      view.widthAnchor.constraint(equalToConstant: width).activate()
      return view
   }

   public static func zeroHeightTableHeaderFooterView() -> UIView {
      return tableHeaderFooterView(height: zeroHeight)
   }

   public static func tableHeaderFooterView(height: CGFloat) -> UIView {
      let view = View().autoresizingView()
      view.accessibilityIdentifier = "tableHeaderFooterView"
      view.setIntrinsicContentSize(CGSize(intrinsicHeight: height))
      view.frame = CGRect(x: 0, y: 0, width: 0, height: height)
      return view
   }
}

extension ViewsFactory {

   public static func nibView<T: UIView>(_: T.Type, withOwner: Any? = nil, options: [UINib.OptionsKey: Any]? = nil) -> T {
      let typeDesctiption = String(describing: T.self)
      let nibName = NSStringFromClass(T.self).components(separatedBy: ".").last ?? ""
      let nib = UINib(nibName: nibName, bundle: Bundle(for: T.self))
      let objects = nib.instantiate(withOwner: withOwner, options: options).compactMap { $0 as? T }
      if objects.count > 1 {
         fatalError("There is more than one view type of \(typeDesctiption) in nib \(nibName).")
      }
      if let view = objects.first {
         return view
      }
      fatalError("View of type \(typeDesctiption) does not exist in nib \(nibName).")
   }
}

#endif
