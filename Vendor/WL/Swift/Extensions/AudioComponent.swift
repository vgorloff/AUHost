//
//  AudioComponent.swift
//  WaveLabs
//
//  Created by Volodymyr Gorlov on 20.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AudioUnit

extension AudioComponentFlags: CustomReflectable {
	public func customMirror() -> Mirror {
		let children: Array<Mirror.Child> = [
			("rawValue", rawValue),
			("Unsearchable", contains(AudioComponentFlags.Unsearchable)),
			("SandboxSafe", contains(AudioComponentFlags.SandboxSafe)),
			("IsV3AudioUnit", contains(AudioComponentFlags.IsV3AudioUnit)),
			("RequiresAsyncInstantiation", contains(AudioComponentFlags.RequiresAsyncInstantiation)),
			("CanLoadInProcess", contains(AudioComponentFlags.CanLoadInProcess))]
		return Mirror(self, children: children)
	}
}

extension AudioComponentInstantiationOptions: CustomReflectable {
	public func customMirror() -> Mirror {
		#if os(OSX)
		let children: Array<Mirror.Child> = [
			("rawValue", rawValue),
			("LoadInProcess", contains(AudioComponentInstantiationOptions.LoadInProcess)),
			("LoadOutOfProcess", contains(AudioComponentInstantiationOptions.LoadOutOfProcess))
		]
		#elseif os(iOS)
		let children: Array<Mirror.Child> = [
			("rawValue", rawValue),
			("LoadOutOfProcess", contains(AudioComponentInstantiationOptions.LoadOutOfProcess))
		]
		#endif
		return Mirror(self, children: children)
	}
}
