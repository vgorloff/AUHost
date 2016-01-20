//
//  MainWindowController.swift
//  AudioUnitExtensionDemo
//
//  Created by Vlad Gorlov on 22.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

	private lazy var mediaLibraryController: NSMediaLibraryBrowserController = {
		let c = NSMediaLibraryBrowserController.sharedMediaLibraryBrowserController()
		c.mediaLibraries = [NSMediaLibrary.Audio]
		return c
	}()

	private var mainController: ViewController {
		guard let c = contentViewController as? ViewController else {
			fatalError()
		}
		return c
	}

	override func windowDidLoad() {
		super.windowDidLoad()
		NSApplication.sharedApplication().applicationDelegate.mediaLibraryLoader.loadMediaLibrary { [weak self] in
			self?.mediaLibraryController.visible = true
		}
	}

	@IBAction private func actionToggleMediaLibraryBrowser(sender: AnyObject?) {
		mediaLibraryController.togglePanel(sender)
	}

	@IBAction private func actionReloadPlugIns(sender: AnyObject?) {
		mainController.reloadEffectsList()
	}
}
