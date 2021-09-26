//
//  UIActivityIndicatorView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIActivityIndicatorView {

   @available(tvOS, unavailable)
   public convenience init(hidesWhenStopped: Bool) {
      #if targetEnvironment(macCatalyst)
      self.init(style: .medium)
      #else
      self.init(style: .gray)
      #endif
      self.hidesWhenStopped = hidesWhenStopped
   }

   public func setAnimating(_ isAnimating: Bool) {
      if isAnimating {
         startAnimating()
      } else {
         stopAnimating()
      }
   }
}
#endif
