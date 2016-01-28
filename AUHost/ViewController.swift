//
//  ViewController.swift
//  AudioUnitExtensionDemo
//
//  Created by Vlad Gorlov on 21.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Cocoa
import AVFoundation
import MediaLibrary
import CoreAudioKit
import WLShared

/**
Links:
* [Developer Forums: MLMediaLibrary in Mavericks not working?](https://devforums.apple.com/message/1125821#1125821)
*/
class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

	@IBOutlet private weak var buttonOpenEffectView: NSButton!
	@IBOutlet private weak var buttonPlay: NSButton!
	@IBOutlet private weak var tableEffects: NSTableView!
	@IBOutlet private weak var tablePresets: NSTableView!
	@IBOutlet private weak var mediaItemView: MediaItemView!

	// MARK: -
	private lazy var log: Logger = Logger(sender: self, context: .Controller)
	private var availableEffects = [AVAudioUnitComponent]()
	private var availablePresets = [AUAudioUnitPreset]()
	private weak var effectViewController: NSViewController? // Temporary store
	private weak var effectWindowController: EffectWindowController?
	private var playbackEngine: PlaybackEngine {
		return NSApplication.sharedApplication().applicationDelegate.playbackEngine
	}
	private var audioUnitDatasource = AudioComponentsUtility()
	private var selectedAUComponent: AVAudioUnitComponent?
	private var canOpenEffectView: Bool {
		guard let component = selectedAUComponent where effectWindowController == nil else {
			return false
		}
		let flags = AudioComponentFlags(rawValue: component.audioComponentDescription.componentFlags)
		let v3AU = flags.contains(AudioComponentFlags.IsV3AudioUnit)
		return component.hasCustomView || v3AU
	}

	// MARK: -
	override func viewDidLoad() {
		super.viewDidLoad()
		Dispatch.Async.Main { [weak self] in guard let s = self else { return }
			s.setUpPlaybackHelper()
			s.setUpMediaItemView()
			s.setUpAudioComponentsUtility()
			s.reloadEffectsList()
		}
	}

	override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
		if let segueID = segue.identifier, let ctrl = segue.destinationController as? EffectWindowController
			where segueID == "S:OpenEffectView" {
				ctrl.contentViewController = effectViewController
				effectWindowController = ctrl
				effectViewController = nil
				buttonOpenEffectView.enabled = false
				ctrl.handlerWindowWillClose = { [weak self] in guard let s = self else { return }
						s.effectWindowController?.contentViewController = nil
						s.effectWindowController = nil
					s.buttonOpenEffectView.enabled = s.canOpenEffectView
				}
		}
	}

	// MARK: -

	func reloadEffectsList() {
		tableEffects.enabled = false
		audioUnitDatasource.updateEffectList { [weak self] effects in guard let s = self else { return }
			s.availableEffects = effects
			s.tableEffects.reloadData()
			s.tableEffects.enabled = true
		}
	}

	// MARK: -

	@IBAction private func actionTogglePlayAudio(sender: AnyObject) {
		do {
			switch playbackEngine.stateID {
			case .Playing:
				playbackEngine.pause()
			case .Paused:
				try playbackEngine.resume()
			case .Stopped:
				try playbackEngine.play()
			case .SettingEffect, .SettingFile: break
			}
		} catch {
			log.logError(error)
		}
	}

	@IBAction private func actionToggleEffectView(sender: AnyObject?) {
		guard canOpenEffectView && effectWindowController == nil else {
			return
		}
		playbackEngine.openEffectView { [weak self] controller in guard let s = self else { return }
			s.effectViewController = controller
			if controller != nil {
				s.performSegueWithIdentifier("S:OpenEffectView", sender: s)
			}
		}
	}

	// MARK: - Private

	private func setUpAudioComponentsUtility() {
		audioUnitDatasource.handlerStateChange = { [weak self] change in guard let s = self else { return }
			switch change {
			case .AudioComponentRegistered:
				s.tableEffects.reloadData()
			case .AudioComponentInstanceInvalidated(_, _):
				s.playbackEngine.selectEffectComponent(nil, completionHandler: nil)
				s.tableEffects.reloadData()
				s.selectedAUComponent = nil
			}
		}
	}

	private func setUpMediaItemView() {
		mediaItemView.onCompleteDragWithObjects = { [weak self] results in
			guard let s = self else { return }
			switch results {
			case .None:
				break
			case .MediaObjects(let mediaObjectsDict):
				let mediaObjects = NSApplication.sharedApplication().applicationDelegate
					.mediaLibraryLoader.mediaObjectsFromPlist(mediaObjectsDict)
				if let firstMediaObject = mediaObjects.first?.1.first?.1, let url = firstMediaObject.URL {
					s.processFileAtURL(url)
				}
			case .FilePaths(let filePaths):
				if let firstFilePath = filePaths.first {
					let url = NSURL(fileURLWithPath: firstFilePath)
					s.processFileAtURL(url)
				}
			}
		}
	}

	private func setUpPlaybackHelper() {
		playbackEngine.changeHandler = { [weak self, weak playbackEngine] change in
			guard let s = self, engine = playbackEngine else { return }
			switch change {
			case .EngineStateChanged(_, _):
				switch engine.stateID {
				case .Playing:
					s.buttonPlay.enabled = true
					s.buttonPlay.title = "Pause"
					s.buttonOpenEffectView.enabled = s.canOpenEffectView
				case .Stopped:
					s.buttonPlay.enabled = true
					s.buttonPlay.title = "Play"
					s.buttonOpenEffectView.enabled = s.canOpenEffectView
				case .Paused:
					s.buttonPlay.enabled = true
					s.buttonPlay.title = "Resume"
					s.buttonOpenEffectView.enabled = s.canOpenEffectView
				case .SettingEffect, .SettingFile:
					s.buttonPlay.enabled = false
					s.buttonOpenEffectView.enabled = false
					break
				}
			}
		}
	}

	private func processFileAtURL(url: NSURL) {
		do {
			defer {
				url.stopAccessingSecurityScopedResource() // Seems working fine without this line
			}
			url.startAccessingSecurityScopedResource() // Seems working fine without this line
			let f = try AVAudioFile(forReading: url)
			mediaItemView.mediaFileURL = url
			try playbackEngine.setFileToPlay(f)
			if playbackEngine.stateID == .Stopped {
				try playbackEngine.play()
			}
			log.logVerbose("File assigned: \(url.absoluteString)")
		} catch {
			log.logError(error)
		}
	}

	// MARK: - NSTableViewDataSource

	func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		switch tableView {
		case tableEffects:
			return availableEffects.count + 1
		case tablePresets:
			return availablePresets.count + 1
		default:
			fatalError("Unknown tableView: \(tableView)")
		}
	}

	func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
		switch tableView {
		case tableEffects:
			if row == 0 {
				return "- No Effect -"
			}
			let component = availableEffects[row - 1]
			return component.name
		case tablePresets:
			if row == 0 {
				return "- Default Preset -"
			}
			let preset = availablePresets[row - 1]
			return preset.name
		default:
			fatalError("Unknown tableView: \(tableView)")
		}
	}

	// MARK: - NSTableViewDelegate

	func tableViewSelectionDidChange(aNotification: NSNotification) {
		guard let tableView = aNotification.object as? NSTableView where tableView.selectedRow >= 0 else {
			return
		}
		func handleTableEffects() {
			let shouldReopenEffectView = (effectWindowController != nil)
			effectWindowController?.close()
			if tableView.selectedRow == 0 {
				log.logVerbose("Clearing effect")
				playbackEngine.selectEffectComponent(nil) { [weak self] _ in
					guard let s = self else { return }
					s.availablePresets.removeAll()
					s.tablePresets.reloadData()
					s.tablePresets.enabled = s.availablePresets.count > 0
				}
				selectedAUComponent = nil
			} else {
				let row = tableView.selectedRow - 1
				if row < availableEffects.count {
					let component = availableEffects[row]
					log.logVerbose("Selecting effect: \"\(component.name)\"")
					playbackEngine.selectEffectComponent(component) { [weak self, weak component] result in
						guard let s = self else { return }
						switch result {
						case .EffectCleared: break
						case .Failure(let e):
							s.log.logError(e)
						case .Success(let effect):
							s.availablePresets = effect.AUAudioUnit.factoryPresets ?? []
							s.tablePresets.reloadData()
							s.tablePresets.enabled = s.availablePresets.count > 0
							s.selectedAUComponent = component
							if shouldReopenEffectView {
								Dispatch.Async.Main { [weak self] in
									self?.actionToggleEffectView(nil)
								}
							}
						}
					}
				}
			}
		}

		func handleTablePresets() {
			if tableView.selectedRow == 0 {
				log.logVerbose("Clearing preset")
				playbackEngine.selectPreset(nil)
			} else {
				let row = tableView.selectedRow - 1
				if row < availablePresets.count {
					let preset = availablePresets[row]
					log.logMarker("Selecting preset: \"\(preset.name)\"")
					playbackEngine.selectPreset(preset)
				}
			}
		}

		switch tableView {
		case tableEffects:
			handleTableEffects()
		case tablePresets:
			handleTablePresets()
		default:
			fatalError("Unknown tableView: \(tableView)")
		}
	}
	
}
