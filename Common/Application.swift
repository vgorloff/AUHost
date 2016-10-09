//
//  Application.swift
//  AUHost
//
//  Created by Vlad Gorlov on 05/10/2016.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Cocoa

class Application: NSApplication {

   let appDelegate = AppDelegate()
   let mediaLibraryLoader = MediaLibraryUtility()
   let playbackEngine = PlaybackEngine()
   static var sharedInstance: Application {
      guard let application = NSApplication.shared() as? Application else {
         fatalError()
      }
      return application
   }

   override init() {
      super.init()
      delegate = appDelegate
   }

   deinit {

   }

   required init?(coder: NSCoder) {
      super.init(coder: coder)
   }

}
