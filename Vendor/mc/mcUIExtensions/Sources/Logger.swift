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
   case service, helper, db, net, view, core, media, processing, io, test, app, controller, animation, events
}

let log = Log<AppLogCategory>(subsystem: "uiExtensions")
