//
//  AttenuatorViewController.swift
//  Attenuator
//
//  Created by Volodymyr Gorlov on 14.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AVFoundation
import CoreAudioKit

open class AttenuatorViewController: AUViewController {

   private lazy var auView = AttenuatorView()
   private var audioUnit: AttenuatorAudioUnit?
   private var parameterObserverToken: AUParameterObserverToken?
   private var isConfigured = false

   public init(au: AttenuatorAudioUnit) {
      audioUnit = au
      super.init(nibName: nil, bundle: nil)
      setupViewIfNeeded()
   }

   public override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   open override func loadView() {
      view = auView
      preferredContentSize = NSSize(width: 200, height: 150)
   }

   open override var preferredMaximumSize: NSSize {
      return NSSize(width: 800, height: 600)
   }

   open override var preferredMinimumSize: NSSize {
      return NSSize(width: 200, height: 150)
   }

   open override func viewDidLoad() {
      super.viewDidLoad()
      setupViewIfNeeded()
   }

   open override func viewDidAppear() {
      super.viewDidAppear()
      auView.startMetering()
   }

   open override func viewWillDisappear() {
      super.viewWillDisappear()
      auView.stopMetering()
   }

   deinit {
      log.deinitialize()
   }
}

extension AttenuatorViewController: AUAudioUnitFactory {

   public func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
      let au = try AttenuatorAudioUnit(componentDescription: componentDescription, options: [])
      audioUnit = au
      DispatchQueue.main.async {
         self.setupViewIfNeeded()
      }
      return au
   }
}

extension AttenuatorViewController {

   private func setupViewIfNeeded() {
      if !isConfigured, let au = audioUnit {
         isConfigured = true
         self.setupUI(au: au)
      }
   }

   private func setupUI(au: AttenuatorAudioUnit) {
      auView.viewLevelMeter.numberOfChannels = au.outputBus.bus.format.channelCount
      auView.updateParameter(parameter: AttenuatorParameter.gain, withValue: au.parameterGain.value)
      parameterObserverToken = au.parameterTree.token(byAddingParameterObserver: { address, value in
         DispatchQueue.main.async { [weak self] in guard let s = self else { return }
            let paramType = AttenuatorParameter.fromRawValue(address)
            s.auView.updateParameter(parameter: paramType, withValue: value)
         }
      })
      auView.handlerParameterDidChaned = { [weak self] _, value in guard let s = self else { return }
         guard let token = s.parameterObserverToken else {
            return
         }
         s.audioUnit?.parameterGain?.setValue(value, originator: token)
      }
      auView.meterRefreshCallback = { [weak self] in
         if let dsp = self?.audioUnit?.dsp {
            return dsp.maximumMagnitude
         }
         return nil
      }
      au.eventHandler = {
         switch $0 {
         case .allocateRenderResources:
            DispatchQueue.main.async { [weak self] in guard let s = self else { return }
               if let outBus = self?.audioUnit?.outputBus {
                  s.auView.viewLevelMeter.numberOfChannels = outBus.bus.format.channelCount
               }
            }
         }
      }
      auView.viewLevelMeter.numberOfChannels = au.outputBus.bus.format.channelCount
   }
}
