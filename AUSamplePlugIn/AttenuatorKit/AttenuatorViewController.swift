//
//  AttenuatorViewController.swift
//  AttenuatorAU
//
//  Created by Volodymyr Gorlov on 14.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreAudioKit
import AVFoundation

public class AttenuatorViewController: AUViewController, AUAudioUnitFactory {
	private var audioUnit: AUAudioUnit? {
		didSet {
			dispatch_async(dispatch_get_main_queue()) { [weak self] in guard let s = self else { return }
				if s.viewLoaded {
					s.connectViewWithAU(s.audioUnit)
				}
			}
		}
	}
	private var parameterObserverToken: AUParameterObserverToken?
	private var parameterGain: AUParameter?
	private var auView: AttenuatorView! {
		return view as! AttenuatorView
	}

	// MARK: - Private

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

	public override func viewDidLoad() {
		super.viewDidLoad()
		connectViewWithAU(audioUnit)
		auView.handlerParameterDidChaned = {[weak self] parameter, value in guard let s = self else { return }
			guard let token = s.parameterObserverToken else {
				return
			}
			s.parameterGain?.setValue(value, originator: token)
		}
	}

	public func createAudioUnitWithComponentDescription(componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
		let au = try AttenuatorAudioUnit(componentDescription: componentDescription, options: [])
		audioUnit = au
		return au
	}

	// MARK: - Private

	private func connectViewWithAU(au: AUAudioUnit?) {
		guard let paramTree = au?.parameterTree else { return }
		parameterGain = paramTree.valueForKey(AttenuatorParameter.Gain.parameterID) as? AUParameter
		parameterObserverToken = paramTree.tokenByAddingParameterObserver { address, value in
			dispatch_async(dispatch_get_main_queue()) { [weak self] in guard let s = self else { return }
				let paramType = AttenuatorParameter.fromRawValue(address)
				s.auView.updateParameter(paramType, withValue: value)
			}
		}
		if let param = parameterGain {
			auView.updateParameter(AttenuatorParameter.Gain, withValue: param.value)
		}
	}
}
