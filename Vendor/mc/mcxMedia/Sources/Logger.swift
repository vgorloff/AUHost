//
//  Logger.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 14.11.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcxFoundationLogging

enum AppLogCategory: String, LogCategory {
   case service, helper, db, net, view, core, media, processing, io, test, app, controller, animation, events, drawing
}

let log = Log<AppLogCategory>(subsystem: "media")
