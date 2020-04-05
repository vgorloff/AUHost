//
//  Logger.swift
//  AUHost
//
//  Created by Vlad Gorlov on 04.08.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import Foundation
import mcFoundationLogging

enum ModuleLogCategory: String, LogCategory {
   case media, controller, view
}

let log = Log<ModuleLogCategory>(subsystem: "host")
