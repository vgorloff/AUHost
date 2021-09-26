//
//  UITableViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

@available(tvOS, unavailable)
extension UITableViewController {

   public func removeRefreshControl() {
      if #available(iOS 10.0, *) {
         tableView.refreshControl = nil
      } else {
         refreshControl = nil
      }
   }

   public func addRefreshControl(_ rc: UIRefreshControl) {
      if #available(iOS 10.0, *) {
         tableView.refreshControl = rc
      } else {
         refreshControl = rc
      }
   }
}
#endif
