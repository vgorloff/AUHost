//
//  UIRefreshControl.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcTypes
import UIKit

@available(tvOS, unavailable)
extension UIRefreshControl {

   public func endRefreshingIfNeeded() {
      if isRefreshing {
         endRefreshing()
      }
   }

   public func beginRefreshingIfNeeded() {
      if !isRefreshing {
         beginRefreshing()
      }
   }
}

@available(tvOS, unavailable)
extension UIRefreshControl {

   public typealias Handler = (() -> Void)

   private struct OBJCAssociationKeys {
      static var refreshControlHandler = "com.mc.refreshControlHandler"
   }

   public convenience init(handler: Handler?) {
      self.init()
      addTarget(self, action: #selector(mcRefreshControlValueChanged(_:)), for: .valueChanged)
      if let handler = handler {
         ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &OBJCAssociationKeys.refreshControlHandler)
      }
   }

   @objc private func mcRefreshControlValueChanged(_ sender: UIRefreshControl) {
      guard sender == self else {
         return
      }
      if let handler: Handler = ObjCAssociation.value(from: self, forKey: &OBJCAssociationKeys.refreshControlHandler) {
         handler()
      }
   }
}
#endif
