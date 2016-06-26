//
//  UnsafeMutableAudioBufferListPointer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 14.06.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AVFoundation

extension UnsafeMutableAudioBufferListPointer {
	var audioBuffers: [AudioBuffer] {
		var result = [AudioBuffer]()
		for audioBufferIndex in 0..<count {
			result.append(self[audioBufferIndex])
		}
		return result
	}
	init(_ pointer: UnsafePointer<AudioBufferList>) {
		self.init(UnsafeMutablePointer<AudioBufferList>(pointer))
	}
}
