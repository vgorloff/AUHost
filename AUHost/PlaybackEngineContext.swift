//
//  PlaybackEngineContext.swift
//  AUHost
//
//  Created by Vlad Gorlov on 18.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AVFoundation
import CoreAudioKit

final class PlaybackEngineContext {

	private lazy var log: Logger = Logger(sender: self, context: .Media)
	internal private(set) var effect: AVAudioUnit?
	private let engine = AVAudioEngine()
	private let player = AVAudioPlayerNode()
	private var file: AVAudioFile?
	private var playbackOffset: AVAudioFramePosition = 0

	var filePlaybackCompleted: AVAudioNodeCompletionHandler?

	// MARK: -
	init() {
		log.initialize()
		engine.attach(player)
	}

	deinit {
		log.deinitialize()
	}

	// MARK: -

	func play() throws {
		try engine.start()
		try startPlayer()
	}

	func pause() {
		if let renderTime = player.lastRenderTime, let playerTime = player.playerTime(forNodeTime: renderTime) {
			playbackOffset += playerTime.sampleTime
		}
		player.pause()
		engine.pause()
	}

	func stopPlayer() {
		if let renderTime = player.lastRenderTime, let playerTime = player.playerTime(forNodeTime: renderTime) {
			playbackOffset += playerTime.sampleTime
		}
		player.stop()
	}

	func startPlayer() throws {
		guard let file = file else {
			throw PlaybackEngineStateError.FileIsNotSet
		}
		scheduleFile(file: file, offset: playbackOffset)
		player.play()
	}

	func scheduleFile() throws {
		guard let file = file else {
			throw PlaybackEngineStateError.FileIsNotSet
		}
		scheduleFile(file: file, offset: playbackOffset)
	}

	func stop() {
		stopPlayer()
		engine.stop()
		engine.reset()
		playbackOffset = 0
	}

	func resume() throws {
		try engine.start()
		player.play()
	}

	func setFileToPlay(_ aFile: AVAudioFile?) {
		defer {
			file = aFile
		}

		guard let fileToPlay = aFile else {
			engine.reset()
			return
		}

		if file != nil {
			engine.disconnectNodeOutput(player) // Should we disconnect?
		}
		if let anEffect = effect {
			// Player -> Effect -> Mixer
			engine.connect(player, to: anEffect, format: fileToPlay.processingFormat)
			engine.connect(anEffect, to: engine.mainMixerNode, format: fileToPlay.processingFormat)
		} else {
			// Player -> Mixer
			engine.connect(player, to: engine.mainMixerNode, format: fileToPlay.processingFormat)
		}
		engine.prepare()
	}

	func selectEffect(componentDescription: AudioComponentDescription?,
		completionHandler: ((PlaybackEngineEffectSelectionResult) -> Void)) {
			guard let desc = componentDescription else {
				DispatchQueue.main.async { [weak self] in
					self?.clearEffect()
					completionHandler(.EffectCleared)
				}
				return
			}
			let flags = AudioComponentFlags(rawValue: desc.componentFlags)
			let canLoadInProcess = flags.contains(AudioComponentFlags.canLoadInProcess)
			let loadOptions: AudioComponentInstantiationOptions = canLoadInProcess ? .loadInProcess : .loadOutOfProcess
			AVAudioUnit.instantiate(with: desc, options: loadOptions) {[weak self] (avAudioUnit, error) in
				if let e = error {
					completionHandler(.Failure(e))
				} else if let effect = avAudioUnit {
					DispatchQueue.main.async { [weak self] in
						self?.assignEffect(effect)
						completionHandler(.Success(effect))
					}
				} else {
					fatalError()
				}
			}
	}

	// MARK: -> Private

	private func clearEffect() {
		defer {
			effect = nil
		}
		if let existedEffect = effect {
			engine.detach(existedEffect) // Will dissconnect node as well
		}
		if let file = file {
			engine.connect(player, to: engine.mainMixerNode, format: file.processingFormat)
		} else {
			engine.reset()
		}
	}

	private func assignEffect(_ anEffect: AVAudioUnit) {
		defer {
			effect = anEffect
		}
		if let existedEffect = effect {
			engine.detach(existedEffect) // Will dissconnect node as well
		}
		engine.attach(anEffect)
		guard let existedFile = file else {
			return
		}
		if effect == nil {
			engine.disconnectNodeOutput(player)
		}
		engine.connect(player, to: anEffect, format: existedFile.processingFormat)
		engine.connect(anEffect, to: engine.mainMixerNode, format: existedFile.processingFormat)
	}

	private func scheduleFile(file: AVAudioFile, offset: AVAudioFramePosition) {
		let framesToPlay = file.length >= offset ? AVAudioFrameCount(file.length - offset) : 0
		var statistics = [String]()
		statistics.append("File duration: \(Double(file.length) / file.fileFormat.sampleRate) s")
		statistics.append("File frames: \(file.length)")
		statistics.append("File samplerate: \(file.fileFormat.sampleRate)")
		statistics.append("File playback offset: \(offset)")
		statistics.append("Frames to play: \(framesToPlay)")
		log.debug(statistics.joined(separator: "; "))
		guard framesToPlay > 0 else {
			log.warn("Nothing to play. Check value of 'playbackOffset' property.")
			return
		}

		/// If there will be problems with playback status, then see this workaround
		/// [ios8 - completionHandler of AVAudioPlayerNode.scheduleFile() is called too early - Stack Overflow]
		/// (http://stackoverflow.com/questions/29427253/completionhandler-of-avaudioplayernode-schedulefile-is-called-too-early)
		player.scheduleSegment(file, startingFrame: offset, frameCount: framesToPlay, at: nil) { [weak self] in
			self?.filePlaybackCompleted?()
		}
	}

}
