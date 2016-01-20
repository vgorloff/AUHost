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
	private weak var effectWindowController: NSWindowController?
	private var playbackEngine: PlaybackEngine {
		return NSApplication.sharedApplication().applicationDelegate.playbackEngine
	}
	private var audioUnitDatasource = AudioComponentsUtility()

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
		if let segueID = segue.identifier, let ctrl = segue.destinationController as? NSWindowController
			where segueID == "S:OpenEffectView" {
				ctrl.contentViewController = effectViewController
				effectWindowController = ctrl
				effectViewController = nil
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
		playbackEngine.openEffectView { [weak self] controller in
			guard let s = self else { return }
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
			}
		}
	}

	private func setUpMediaItemView() {
		mediaItemView.onCompleteDragWithObjects = { [weak self] results in
			guard let s = self else { return }
			switch results {
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
				case .Stopped:
					s.buttonPlay.title = "Play"
				case .Paused:
					s.buttonPlay.title = "Resume"
				case .SettingEffect, .SettingFile:
					s.buttonPlay.enabled = false
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
			let shouldOpenEffectView = (effectWindowController != nil)
			effectWindowController?.close()
			if tableView.selectedRow == 0 {
				log.logVerbose("Clearing effect")
				buttonOpenEffectView.enabled = false
				playbackEngine.selectEffectComponent(nil) { [weak self] _ in
					guard let s = self else { return }
					s.availablePresets.removeAll()
					s.tablePresets.reloadData()
					s.tablePresets.enabled = s.availablePresets.count > 0
				}
			} else {
				buttonOpenEffectView.enabled = true
				let row = tableView.selectedRow - 1
				if row < availableEffects.count {
					let component = availableEffects[row]
					log.logVerbose("Selecting effect: \"\(component.name)\"")
					playbackEngine.selectEffectComponent(component) { [weak self] result in
						guard let s = self else { return }
						switch result {
						case .EffectCleared: break
						case .Failure(let e):
							s.log.logError(e)
						case .Success(let effect):
							s.availablePresets = effect.AUAudioUnit.factoryPresets ?? []
							s.tablePresets.reloadData()
							s.tablePresets.enabled = s.availablePresets.count > 0
						}
					}
				}
				if shouldOpenEffectView {
					Dispatch.Async.Main { [weak self] in
						self?.actionToggleEffectView(nil)
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
