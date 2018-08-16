//
//  main.swift
//  AUHost
//
//  Created by Vlad Gorlov on 05/10/2016.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AppKit
import Foundation

autoreleasepool {
   // Even if we loading application manually we need to setup `Info.plist` key:
   // <key>NSPrincipalClass</key>
   // <string>NSApplication</string>
   // Otherwise Application will be loaded in `low resolution` mode.
   let app = Application.shared
   app.setActivationPolicy(.regular)
   app.run()
}
