//
//  SmartDispatchSourceUserDataOr.swift
//  mcCore
//
//  Created by Vlad Gorlov on 10.11.17.
//  Copyright © 2017 Demo. All rights reserved.
//

import Foundation

public final class SmartDispatchSourceUserDataOr: SmartDispatchSource {
   public init(queue: DispatchQueue? = nil) {
      super.init()
      dispatchSource = DispatchSource.makeUserDataOrSource(queue: queue)
   }

   public func mergeData(value: UInt) {
      guard let dispatchSourceInstance = dispatchSource as? DispatchSourceUserDataOr else {
         return
      }
      dispatchSourceInstance.or(data: value)
   }
}
