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

   fileprivate var audioUnit: AttenuatorAudioUnit?
   fileprivate var audioUnitController: AttenuatorViewController?
   private var audioUnitComponent: AVAudioUnitComponent?
   var uiModel: MainViewUIModel? {
      willSet {
         uiModel?.uiDelegate = nil
      }
      didSet {
         uiModel?.uiDelegate = self
      }
   }

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
   lazy var version = UInt32(Date.timeIntervalSinceReferenceDate)
   override func viewDidLoad() {
      super.viewDidLoad()
      setupHandlers()
      setupActions()
      AUAudioUnit.registerSubclass(AttenuatorAudioUnit.self, as: acd, name: "WaveLabs: Attenuator (Local)", version: version)
      let registeredComponents = AVAudioUnitComponentManager.shared().components(matching: acd)
      audioUnitComponent = registeredComponents.first
   }
}

extension ViewController: MainViewUIHandling {
   func handleEvent(_ event: MainViewUIModel.UIEvent) {
      switch event {
      case .playbackEngineStageChanged(let state):
         switch state {
         case .Playing:
            buttonPlay.isEnabled = true
            buttonPlay.title = "Pause"
         case .Stopped:
            buttonPlay.isEnabled = true
            buttonPlay.title = "Play"
         case .Paused:
            buttonPlay.isEnabled = true
            buttonPlay.title = "Resume"
         case .SettingEffect, .SettingFile:
            buttonPlay.isEnabled = false
         }
      case .selectMedia(let url):
         mediaItemView.mediaFileURL = url
      case .didSelectEffect(let error):
         if error == nil {
            buttonLoadAU.title = "Unload AU"
         }
      case .willSelectEffect:
         break
      case .didClearEffect:
         buttonLoadAU.title = "Load AU"
         closeEffectView()
      default:
         break
      }
   }
}

extension ViewController {

   fileprivate func setupHandlers() {
      mediaItemView.onCompleteDragWithObjects = { [weak self] in
         self?.uiModel?.handlePastboard($0)
      }
   }

   fileprivate func setupActions() {
      buttonPlay.target = self
      buttonPlay.action = #selector(actionTogglePlayAudio(_:))
      buttonPlay.isEnabled = false
      buttonPlay.title = "Play"

      buttonLoadAU.target = self
      buttonLoadAU.title = "Load AU"
      buttonLoadAU.action = #selector(actionToggleEffect(_:))
   }

   @objc private func actionToggleEffect(_ sender: AnyObject) {
      let component: AVAudioUnitComponent? = (audioUnit == nil) ? audioUnitComponent : nil
      uiModel?.selectEffect(component) { [weak self] in
         if let au = $0.auAudioUnit as? AttenuatorAudioUnit {
            self?.openEffectView(au: au)
         }
      }
   }

   @objc private func actionTogglePlayAudio(_ sender: AnyObject) {
      uiModel?.togglePlay()
   }

   private func openEffectView(au: AttenuatorAudioUnit) {
      audioUnit = au
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
      audioUnit = nil
      audioUnitController?.view.removeFromSuperview()
      audioUnitController?.removeFromParentViewController()
      audioUnitController = nil
   }
}
