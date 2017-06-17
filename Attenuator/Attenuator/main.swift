//
//  main.swift
//  AUHost
//
//  Created by Vlad Gorlov on 05/10/2016.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Foundation
import AppKit

let app = AppConfig.applicationClass.shared
app.setActivationPolicy(.regular) // Configure as a regular app (appearing in Dock and (possibly) having UI)

// This will assign property `NSApplication.mainMenu` as well.
AppConfig.mainMenu.instantiate(withOwner: app, topLevelObjects: nil)

let windowController = AppConfig.mainWindowController
windowController.window?.makeKeyAndOrderFront(nil)

app.activate(ignoringOtherApps: true)
app.run()

