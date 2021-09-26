//
//  NSNotification.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 01.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation

extension Notification {

   public func post(center: NotificationCenter = NotificationCenter.default) {
      center.post(self)
   }
}
