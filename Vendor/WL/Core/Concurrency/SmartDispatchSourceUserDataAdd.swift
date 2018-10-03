//
//  SmartDispatchSourceUserDataAdd.swift
//  mcCore
//
//  Created by Vlad Gorlov on 10.11.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation

public final class SmartDispatchSourceUserDataAdd: SmartDispatchSource {
   public init(queue: DispatchQueue? = nil) {
      super.init()
      dispatchSource = DispatchSource.makeUserDataAddSource(queue: queue)
   }

   public func mergeData(value: UInt) {
      guard let dispatchSourceInstance = dispatchSource as? DispatchSourceUserDataAdd else {
         return
      }
      dispatchSourceInstance.add(data: value)
   }
}
