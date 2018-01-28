//
//  SmartDispatchSourceType.swift
//  mcCore
//
//  Created by Vlad Gorlov on 08.11.17.
//  Copyright © 2017 Demo. All rights reserved.
//

import Foundation

public protocol SmartDispatchSourceType: class {
   func resume()
   func suspend()
   func setEventHandler(qos: DispatchQoS, flags: DispatchWorkItemFlags, handler: (() -> Void)?)
}
