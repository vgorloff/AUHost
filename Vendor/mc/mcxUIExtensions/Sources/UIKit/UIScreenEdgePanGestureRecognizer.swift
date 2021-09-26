//
//  UIScreenEdgePanGestureRecognizer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

@available(tvOS, unavailable)
extension UIScreenEdgePanGestureRecognizer {

   public convenience init(edges: UIRectEdge) {
      self.init()
      self.edges = edges
   }
}
#endif
