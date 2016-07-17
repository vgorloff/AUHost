//
//  AppDelegate.swift
//  Attenuator
//
//  Created by Volodymyr Gorlov on 14.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}

	func applicationDidFinishLaunching(aNotification: Notification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(aNotification: Notification) {
		// Insert code here to tear down your application
	}


}
