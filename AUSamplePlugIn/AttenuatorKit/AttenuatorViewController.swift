//
//  AttenuatorViewController.swift
//  AttenuatorAU
//
//  Created by Volodymyr Gorlov on 14.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreAudioKit
import AVFoundation
import WLExtShared

public class AttenuatorViewController: AUViewController, AUAudioUnitFactory {
	private var audioUnit: AttenuatorAudioUnit?
	// MARK: -

	public override func loadView() {
		var topLevelObjects: NSArray?
		guard
			let nib = NSNib(nibNamed: String(AttenuatorViewController.self), bundle: NSBundle(forClass: AttenuatorViewController.self)) where
			nib.instantiateWithOwner(self, topLevelObjects: &topLevelObjects), let objects = topLevelObjects else {
				fatalError()
		}
		for object in objects {
			if let v = object as? AttenuatorView {
				view = v
				return
			}
		}
		fatalError()
	}

	override public func viewDidLoad() {
		super.viewDidLoad()
	}

	override public func viewDidAppear() {
		super.viewDidAppear()
		audioUnit?.view?.startMetering()
	}

	override public func viewWillDisappear() {
		super.viewWillDisappear()
		audioUnit?.view?.stopMetering()
	}

	public func createAudioUnitWithComponentDescription(componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
		let au = try AttenuatorAudioUnit(componentDescription: componentDescription, options: [])
		audioUnit = au
		audioUnit?.view = view as? AttenuatorView
		return au
	}

}
