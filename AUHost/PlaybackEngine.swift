//
//  PlaybackEngine.swift
//  AUHost
//
//  Created by Vlad Gorlov on 17.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AVFoundation
import CoreAudioKit

enum PlaybackEngineStateError: ErrorType {
	case FileIsNotSet
}

enum PlaybackEngineEffectSelectionResult {
	case EffectCleared
	case Success(AVAudioUnit)
	case Failure(ErrorType)
}

enum PlaybackEngineState {
	case Stopped, Playing, Paused, SettingFile, SettingEffect
}

enum PlaybackEngineEvent {
	case Play, Pause, Resume, Stop
	case SetFile(AVAudioFile?)
	case SetEffect(AudioComponentDescription?, (PlaybackEngineEffectSelectionResult -> Void))
}

typealias SMGraphType = StateMachineGraph<PlaybackEngineState,
	PlaybackEngineEvent, PlaybackEngineContext>
private let gStateMachineGraph = SMGraphType(initialState: .Stopped) { (state, event) in
	switch state {
	case .Stopped:
		switch event {
		case .Play: return (.Playing, { ctx in try ctx.play() } )
		case .SetFile(let file): return (.SettingFile, { ctx in ctx.setFileToPlay(file) })
		case .SetEffect(let component, let callback): return (.SettingEffect, { ctx in
			ctx.selectEffect(component, completionHandler: callback)
		})
		case .Pause, .Resume, .Stop: return nil
		}
	case .Playing:
		switch event {
		case .Pause: return (.Paused, { ctx in ctx.pause() })
		case .Stop: return (.Stopped, { ctx in ctx.stop() })
		case .SetFile, .Play, .Resume: return nil
		case .SetEffect(let component, let callback): return (.SettingEffect, { ctx in
			ctx.stopPlayer()
			ctx.selectEffect(component, completionHandler: callback)
		})
		}
	case .Paused:
		switch event {
		case .Resume: return (.Playing, { ctx in try ctx.resume() })
		case .Stop: return (.Stopped, { ctx in ctx.stop() })
		case .SetFile, .Play, .Pause: return nil
		case .SetEffect(let component, let callback): return (.SettingEffect, { ctx in
			ctx.stopPlayer()
			ctx.selectEffect(component, completionHandler: callback)
		})
		}
	case .SettingEffect:
		switch event {
		case .SetEffect, .SetFile, .Resume: return nil
		case .Stop: return (.Stopped, nil)
		case .Play: return (.Playing, { ctx in try ctx.startPlayer() } )
		case .Pause: return (.Paused, { ctx in try ctx.scheduleFile() } )
		}
	case .SettingFile:
		switch event {
		case .SetEffect, .SetFile, .Resume, .Play, .Pause: return nil
		case .Stop: return (.Stopped, nil)
		}
	}
}

final class PlaybackEngine {

	enum Change {
		case EngineStateChanged(old: PlaybackEngineState, new: PlaybackEngineState)
	}

	// MARK: -

	private lazy var log: Logger = {return Logger(sender: self, context: .Media)}()
	private var sm: StateMachine<SMGraphType>
	private let context = PlaybackEngineContext()
	private let _stateAccessLock: NonRecursiveLocking = SpinLock()

	// MARK: -

	var changeHandler: (Change -> Void)?
	var stateID: PlaybackEngineState {
		return _stateAccessLock.synchronized{
			return sm.state
		}
	}

	// MARK: -

	init() {
		sm = StateMachine(context: context, graph: gStateMachineGraph)
		sm.stateChangeHandler = { [weak self] oldState, event, newState in
			self?.log.logVerbose("State changed: \(oldState) => \(newState)")
			Dispatch.Async.Main { [weak self] in
				self?.changeHandler?(Change.EngineStateChanged(old: oldState, new: newState))
			}
		}
		context.filePlaybackCompleted = { [weak self] in guard let s = self else { return }
			s.log.logVerbose("Playback stopped or file finished playing. Current state: \(s.stateID)")
			guard s.stateID == .Playing else {
				return
			}
			Dispatch.Async.Main { [weak self] in guard let s = self else { return }
				do {
					try s.sm.handleEvent(.Stop)
				} catch {
					s.log.logError(error)
				}
			}
		}
		log.logInit()
	}

	deinit {
		log.logDeinit()
	}

	// MARK: -

	func setFileToPlay(fileToPlay: AVAudioFile) throws {
		switch stateID {
		case .SettingEffect, .SettingFile, .Stopped: break
		case .Playing, .Paused:
			try sm.handleEvent(.Stop)
		}
		try sm.handleEvent(.SetFile(fileToPlay))
		try sm.handleEvent(.Stop)
	}

	func stop() {
		trythrow(try sm.handleEvent(.Stop))
	}

	func pause() {
		trythrow(try sm.handleEvent(.Pause))
	}

	func resume() throws {
		try sm.handleEvent(.Resume)
	}

	func play() throws {
		try sm.handleEvent(.Play)
	}

	func openEffectView(completionHandler: (NSViewController?) -> Void) {
		if let au = context.effect?.AUAudioUnit {
			au.requestViewControllerWithCompletionHandler(completionHandler)
		} else {
			completionHandler(nil)
		}
	}

	func selectPreset(preset: AUAudioUnitPreset?) {
		guard let avau = context.effect else {
			return
		}
		guard let p = preset else {
			avau.AUAudioUnit.currentPreset = nil
			return
		}
		let presetList = avau.AUAudioUnit.factoryPresets ?? []
		let matchedPresets = presetList.filter{ $0.number == p.number }
		guard let matchedPreset = matchedPresets.first else {
			avau.AUAudioUnit.currentPreset = nil
			return
		}
		avau.AUAudioUnit.currentPreset = matchedPreset
	}

	func selectEffectComponent(component: AVAudioUnitComponent?, completionHandler: (PlaybackEngineEffectSelectionResult -> Void)?) {
		selectEffectWithComponentDescription(component?.audioComponentDescription, completionHandler: completionHandler)
	}

	// MARK: - Private

	private func selectEffectWithComponentDescription(componentDescription: AudioComponentDescription?,
		completionHandler: (PlaybackEngineEffectSelectionResult -> Void)?) {
			var possibleRelaunchEvent: PlaybackEngineEvent?
			switch stateID {
			case .SettingEffect, .SettingFile: break
			case .Stopped: possibleRelaunchEvent = .Stop
			case .Paused: possibleRelaunchEvent = .Pause
			case .Playing: possibleRelaunchEvent = .Play
			}
			let sema = Dispatch.Semaphore()
			let event = PlaybackEngineEvent.SetEffect(componentDescription, {result in
				completionHandler?(result)
				sema.signal()
			})
			Dispatch.Async.UserInitiated { [weak self] in guard let s = self else { return }
				trythrow({try s.sm.handleEvent(event)})
				sema.wait() {
					guard let relaunchEvent = possibleRelaunchEvent else {
						return
					}
					trythrow({try s.sm.handleEvent(relaunchEvent)})
				}
			}
	}
}
