//
//  Logger.swift
//  Attenuator
//
//  Created by Vlad Gorlov on 04.08.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import Foundation

enum ModuleLogCategory: String, LogCategory {
   case media, controller
}

let log = Log<ModuleLogCategory>(subsystem: "kit")
