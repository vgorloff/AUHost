//
//  UIPanGestureRecognizer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIPanGestureRecognizer {

   public func relativeTranslation(in view: UIView) -> CGPoint {
      let absoluteValue = translation(in: view)
      let relativeValue = CGPoint(x: absoluteValue.x / view.bounds.width, y: absoluteValue.y / view.bounds.height)
      return relativeValue
   }
}

#endif
