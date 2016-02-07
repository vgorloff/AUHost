//
//  EffectWindowController.swift
//  AUHost
//
//  Created by Vlad Gorlov on 16.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AppKit
import WLCore

class EffectWindowController: NSWindowController, NSWindowDelegate {

	var handlerWindowWillClose: (Void -> Void)?

	override func awakeFromNib() {
		super.awakeFromNib()
		windowFrameAutosaveName = StringFromClass(EffectWindowController.self) + ":WindowFrame"
	}

	// MARK: - NSWindowDelegate

	func windowWillClose(notification: NSNotification) {
		handlerWindowWillClose?()
	}
}
