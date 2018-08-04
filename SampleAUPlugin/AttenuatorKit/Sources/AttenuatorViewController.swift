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

   private var auView: AttenuatorView?
   private var audioUnit: AttenuatorAudioUnit?
   private var parameterObserverToken: AUParameterObserverToken?
   private var observers = [NotificationObserver]()
   private var isConfigured = false

   public convenience init?(au: AttenuatorAudioUnit) {
      self.init(nibName: nil, bundle: nil)
      audioUnit = au
      if let auView = auView {
         setupView(au: au, auView: auView)
      }
   }

   public override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
   }

   public required init?(coder: NSCoder) {
      super.init(coder: coder)
   }

   open override func loadView() {
      let nibName = NSNib.Name(String(describing: AttenuatorViewController.self))
      guard let nib = NSNib(nibNamed: nibName, bundle: Bundle(for: AttenuatorViewController.self)) else {
         fatalError()
      }
      let objects = nib.instantiate(withOwner: self)
      guard let v = (objects.map { $0 as? AttenuatorView }.compactMap { $0 }).first else {
         fatalError()
      }
      view = v
      auView = v
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
      auView?.startMetering()
   }

   open override func viewWillDisappear() {
      super.viewWillDisappear()
      auView?.stopMetering()
   }

   deinit {
      observers.removeAll()
   }
}

extension AttenuatorViewController: AUAudioUnitFactory {

   public func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
      let au = try AttenuatorAudioUnit(componentDescription: componentDescription, options: [])
      audioUnit = au
      setupViewIfNeeded()
      return au
   }
}

extension AttenuatorViewController {

   private func setupViewIfNeeded() {
      DispatchQueue.main.async {
         if !self.isConfigured {
            self.isConfigured = true
            if let au = self.audioUnit, let view = self.auView {
               self.setupView(au: au, auView: view)
            }
         }
      }
   }

   private func setupView(au: AttenuatorAudioUnit, auView: AttenuatorView) {
      auView.viewLevelMeter.numberOfChannels = au.outputBus.bus.format.channelCount
      auView.updateParameter(parameter: AttenuatorParameter.gain, withValue: au.parameterGain.value)
      parameterObserverToken = au.parameterTree.token(byAddingParameterObserver: { address, value in
         DispatchQueue.main.async { [weak self] in guard let s = self else { return }
            let paramType = AttenuatorParameter.fromRawValue(address)
            s.auView?.updateParameter(parameter: paramType, withValue: value)
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
                  s.auView?.viewLevelMeter.numberOfChannels = outBus.bus.format.channelCount
               }
            }
         }
      }
      auView.viewLevelMeter.numberOfChannels = au.outputBus.bus.format.channelCount
   }
}
