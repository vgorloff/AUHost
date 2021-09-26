//
//  NotificationCenter.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 02.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

extension NotificationCenter {

   public func post(name: NSNotification.Name) {
      post(name: name, object: nil)
   }

   public func post(name: NSNotification.Name, userInfo: [AnyHashable: Any]) {
      post(name: name, object: nil, userInfo: userInfo)
   }
}
