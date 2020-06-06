//
//  UISearchBar.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

@available(tvOS, unavailable)
extension UISearchBar {

   public func setShowsCancelButtonIfNeeded(_ shouldShow: Bool, animated: Bool) {
      if shouldShow {
         showCancelButtonIfNeeded(animated: animated)
      } else {
         hideCancelButtonIfNeeded(animated: animated)
      }
   }

   public func showCancelButtonIfNeeded(animated: Bool) {
      if !showsCancelButton {
         setShowsCancelButton(true, animated: animated)
      }
   }

   public func hideCancelButtonIfNeeded(animated: Bool) {
      if showsCancelButton {
         setShowsCancelButton(false, animated: animated)
      }
   }
}
#endif
