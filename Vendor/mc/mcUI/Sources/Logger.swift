//
//  Logger.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 04.06.19.
//  Copyright © 2019 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcFoundationLogging

enum AppLogCategory: String, LogCategory {
   case view
}

let log = Log<AppLogCategory>(subsystem: "ui")
