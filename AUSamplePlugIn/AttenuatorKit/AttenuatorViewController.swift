//
//  AttenuatorViewController.swift
//  Attenuator
//
//  Created by Volodymyr Gorlov on 14.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreAudioKit
import AVFoundation

public class AttenuatorViewController: AUViewController, AUAudioUnitFactory {
	private var audioUnit: AttenuatorAudioUnit?
	// MARK: -

	public override func loadView() {
		var topLevelObjects = NSArray()
		guard let nib = NSNib(nibNamed: String(AttenuatorViewController.self), bundle: Bundle(for: AttenuatorViewController.self))
         where nib.instantiate(withOwner: self, topLevelObjects: &topLevelObjects) else {
				fatalError()
		}
		for object in topLevelObjects {
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

	public func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
		let au = try AttenuatorAudioUnit(componentDescription: componentDescription, options: [])
		audioUnit = au
		audioUnit?.view = view as? AttenuatorView
		return au
	}

}
