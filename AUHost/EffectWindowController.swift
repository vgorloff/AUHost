//
//  EffectWindowController.swift
//  AUHost
//
//  Created by Vlad Gorlov on 16.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AppKit
import WLShared

class EffectWindowController: NSWindowController {
	override func awakeFromNib() {
		super.awakeFromNib()
		windowFrameAutosaveName = StringFromClass(EffectWindowController.self) + ":WindowFrame"
	}
}
