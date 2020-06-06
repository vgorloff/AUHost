//
//  Logger.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 14.11.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcFoundationLogging

enum AppLogCategory: String, LogCategory {
   case processing
}

let log = Log<AppLogCategory>(subsystem: "media.au")
