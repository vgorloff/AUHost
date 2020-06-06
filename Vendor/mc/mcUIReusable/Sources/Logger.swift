//
//  Logger.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 18.11.18.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcFoundationLogging

enum AppLogCategory: String, LogCategory {
   case processing, controller, animation, app, view, media
}

let log = Log<AppLogCategory>(subsystem: "uiKit")
