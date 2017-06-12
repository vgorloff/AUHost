//
//  AttenuatorViewController.swift
//  Attenuator
//
//  Created by Volodymyr Gorlov on 14.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreAudioKit
import AVFoundation

open class AttenuatorViewController: AUViewController, AUAudioUnitFactory {
   private var audioUnit: AttenuatorAudioUnit?
   private var parameterObserverToken: AUParameterObserverToken?

   convenience public init?(au: AttenuatorAudioUnit) {
      self.init(nibName: nil, bundle: nil)
      audioUnit = au
      if let auView = auView {
         setUpView(au: au, auView: auView)
      }
   }

   public override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
   }

   public required init?(coder: NSCoder) {
      super.init(coder: coder)
   }

   open override func loadView() {
      var topLevelObjects: NSArray?
      guard let nib = NSNib(nibNamed: String(describing: AttenuatorViewController.self),
                            bundle: Bundle(for: AttenuatorViewController.self)),
         nib.instantiate(withOwner: self, topLevelObjects: &topLevelObjects) else {
            fatalError()
      }
      for object in topLevelObjects ?? [] {
         if let v = object as? AttenuatorView {
            view = v
            return
         }
      }
      fatalError()
   }

   var auView: AttenuatorView? {
      return view as? AttenuatorView
   }

   override open func viewDidLoad() {
      super.viewDidLoad()
   }

   override open func viewDidAppear() {
      super.viewDidAppear()
      auView?.startMetering()
   }

   override open func viewWillDisappear() {
      super.viewWillDisappear()
      auView?.stopMetering()
   }

   public func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
      let au = try AttenuatorAudioUnit(componentDescription: componentDescription, options: [])
      audioUnit = au
      if let auView = auView {
         DispatchQueue.main.async { [weak self] in
            self?.setUpView(au: au, auView: auView)
         }
      }
      return au
   }

   private func setUpView(au: AttenuatorAudioUnit, auView: AttenuatorView) {
      auView.viewLevelMeter.numberOfChannels = au.outputBus.bus.format.channelCount
      auView.updateParameter(parameter: AttenuatorParameter.gain, withValue: au.parameterGain.value)
      parameterObserverToken = au.parameterTree.token(byAddingParameterObserver: { address, value in
         DispatchQueue.main.async { [weak self] in guard let s = self else { return }
            let paramType = AttenuatorParameter.fromRawValue(address)
            s.auView?.updateParameter(parameter: paramType, withValue: value)
         }
      })
      auView.handlerParameterDidChaned = {[weak self] parameter, value in guard let s = self else { return }
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
                  s.auView?.viewLevelMeter.numberOfChannels = outBus.bus.format.channelCount
               }
            }
         }
      }
      auView.viewLevelMeter.numberOfChannels = au.outputBus.bus.format.channelCount
   }

}
