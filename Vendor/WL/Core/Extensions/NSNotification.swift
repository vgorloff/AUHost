//
//  NSNotification.swift
//  mcCore
//
//  Created by Volodymyr Gorlov on 01.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

extension Notification {

   public func post(center: NotificationCenter = NotificationCenter.default) {
      center.post(self)
   }
}
