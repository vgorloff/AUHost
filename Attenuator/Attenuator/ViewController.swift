//
//  ViewController.swift
//  Attenuator
//
//  Created by Volodymyr Gorlov on 14.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Cocoa
import AVFoundation
import AttenuatorKit

class ViewController: NSViewController {

   @IBOutlet fileprivate weak var containerView: NSView!
   @IBOutlet fileprivate weak var mediaItemView: MediaItemView!
   @IBOutlet fileprivate weak var buttonPlay: NSButton!
   @IBOutlet fileprivate weak var buttonLoadAU: NSButton!
   fileprivate var playbackEngine: PlaybackEngine {
      return Application.sharedInstance.playbackEngine
   }
   fileprivate var audioUnit: AttenuatorAudioUnit?
   fileprivate var audioUnitController: AttenuatorViewController?

   fileprivate lazy var acd: AudioComponentDescription = {
      let flags = AudioComponentFlags.sandboxSafe.rawValue
//      let flags = AudioComponentFlags.isV3AudioUnit.rawValue
//         | AudioComponentFlags.requiresAsyncInstantiation.rawValue
//         | AudioComponentFlags.sandboxSafe.rawValue
//         | AudioComponentFlags.canLoadInProcess.rawValue
      let acd = AudioComponentDescription(componentType: kAudioUnitType_Effect, componentSubType: "attr".OSTypeValue,
                                          componentManufacturer: "wlUA".OSTypeValue,
                                          componentFlags: flags, componentFlagsMask: 0)
      return acd
   }()
   override func viewDidLoad() {
      super.viewDidLoad()
      setUpPlaybackHelper()
      setUpMediaItemView()
      setUpActions()
      AUAudioUnit.registerSubclass(AttenuatorAudioUnit.self, as: acd, name: "WaveLabs: Attenuator (Local)", version: UInt32.max)
   }
}

extension ViewController {

   fileprivate func setUpMediaItemView() {
      mediaItemView.onCompleteDragWithObjects = { [weak self] results in
         guard let s = self else { return }
         switch results {
         case .None:
            break
         case .MediaObjects(let mediaObjectsDict):
            let mediaObjects = Application.sharedInstance.mediaLibraryLoader.mediaObjectsFromPlist(
               pasteboardPlist: mediaObjectsDict)
            if let firstMediaObject = mediaObjects.first?.1.first?.1, let url = firstMediaObject.url {
               s.processFileAtURL(url)
            }
         case .FilePaths(let filePaths):
            if let firstFilePath = filePaths.first {
               let url = NSURL(fileURLWithPath: firstFilePath)
               s.processFileAtURL(url as URL)
            }
         }
      }
   }

   fileprivate func setUpPlaybackHelper() {
      playbackEngine.changeHandler = { [weak self, weak playbackEngine] change in
         guard let s = self, let engine = playbackEngine else { return }
         switch change {
         case .EngineStateChanged(_, _):
            switch engine.stateID {
            case .Playing:
               s.buttonPlay.isEnabled = true
               s.buttonPlay.title = "Pause"
            case .Stopped:
               s.buttonPlay.isEnabled = true
               s.buttonPlay.title = "Play"
            case .Paused:
               s.buttonPlay.isEnabled = true
               s.buttonPlay.title = "Resume"
            case .SettingEffect, .SettingFile:
               s.buttonPlay.isEnabled = false
            }
         }
      }
   }

   fileprivate func setUpActions() {
      buttonPlay.target = self
      buttonPlay.action = #selector(actionTogglePlayAudio(_:))
      buttonPlay.isEnabled = false
      buttonPlay.title = "Play"

      buttonLoadAU.target = self
      buttonLoadAU.title = "Load AU"
      buttonLoadAU.action = #selector(actionToggleEffect(_:))
   }

   @objc private func actionToggleEffect(_ sender: AnyObject) {
      let componentDescription: AudioComponentDescription? = audioUnit == nil ? acd : nil
      playbackEngine.selectEffect(componentDescription: componentDescription) { [weak self] in
         switch $0 {
         case .EffectCleared:
            self?.buttonLoadAU.title = "Load AU"
            self?.audioUnit = nil
            self?.closeEffectView()
         case .Failure(let error):
            Logger.error(subsystem: .Controller, category: .Handle, message: error)
         case .Success(let au):
            if let au = au.auAudioUnit as? AttenuatorAudioUnit {
               self?.audioUnit = au
               self?.buttonLoadAU.title = "Unload AU"
               self?.openEffectView(au: au)
            }
         }
      }
   }

   @objc private func actionTogglePlayAudio(_ sender: AnyObject) {
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
         Logger.error(subsystem: .Controller, category: .Handle, message: error)
      }
   }

   private func processFileAtURL(_ url: URL) {
      do {
         defer {
            url.stopAccessingSecurityScopedResource() // Seems working fine without this line
         }
         _ = url.startAccessingSecurityScopedResource() // Seems working fine without this line
         let f = try AVAudioFile(forReading: url)
         mediaItemView.mediaFileURL = url
         try playbackEngine.setFileToPlay(f)
         if playbackEngine.stateID == .Stopped {
            try playbackEngine.play()
         }
         Logger.debug(subsystem: .Controller, category: .Lifecycle, message: "File assigned: \(url.absoluteString)")
      } catch {
         Logger.error(subsystem: .Controller, category: .Lifecycle, message: error)
      }
   }

   private func openEffectView(au: AttenuatorAudioUnit) {
      if let ctrl = AttenuatorViewController(au: au) {
         ctrl.view.translatesAutoresizingMaskIntoConstraints = false
         addChildViewController(ctrl)
         containerView.addSubview(ctrl.view)
         let cH = NSLayoutConstraint.constraints(withVisualFormat: "|[subview]|",
                                                 options: [], metrics: nil, views:["subview": ctrl.view])
         let cV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[subview]|",
                                                 options: [], metrics: nil, views:["subview": ctrl.view])
         containerView.addConstraints(cH)
         containerView.addConstraints(cV)
         audioUnitController = ctrl
      }
   }

   private func closeEffectView() {
      audioUnitController?.view.removeFromSuperview()
      audioUnitController?.removeFromParentViewController()
      audioUnitController = nil
   }
}
