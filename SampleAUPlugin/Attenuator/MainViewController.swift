//
//  MainViewController.swift
//  SampleAUPlugin
//
//  Created by Volodymyr Gorlov on 14.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AVFoundation
import Cocoa
import mcAppKit
import mcUI

class MainViewController: ViewController {

   private lazy var stackView = StackView(axis: .vertical).autolayoutView()
   private lazy var mediaItemView = MediaItemView().autolayoutView()
   private lazy var containerView = View().autolayoutView()

   private var audioUnit: AttenuatorAudioUnit?
   private var audioUnitController: AttenuatorViewController?
   private var audioUnitComponent: AVAudioUnitComponent?

   let viewModel = MainViewUIModel()

   private lazy var acd: AudioComponentDescription = {
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

   override init() {
      super.init()
      AUAudioUnit.registerSubclass(AttenuatorAudioUnit.self, as: acd, name: "WaveLabs: Attenuator (Local)", version: version)
      let registeredComponents = AVAudioUnitComponentManager.shared().components(matching: acd)
      audioUnitComponent = registeredComponents.first
   }

   required init?(coder: NSCoder) {
      fatalError("Please use this class from code.")
   }
}

extension MainViewController {

   func handleEvent(_ event: MainViewUIModel.Event, _ state: MainViewUIModel.State) {
      switch event {
      case .selectMedia(let url):
         mediaItemView.mediaFileURL = url
      case .didClearEffect:
         closeEffectView()
      default:
         break
      }
   }
}

extension MainViewController {

   override func setupUI() {

      view.addSubviews(stackView)

      stackView.addArrangedSubviews(mediaItemView, containerView)
      stackView.distribution = .fill
      stackView.spacing = 0
   }

   override func setupLayout() {
      LayoutConstraint.pin(to: .bounds, stackView).activate()
      LayoutConstraint.constrainHeight(constant: 120, relation: .greaterThanOrEqual, mediaItemView).activate()
   }

   override func setupHandlers() {
      mediaItemView.onCompleteDragWithObjects = { [weak self] in
         self?.viewModel.handlePastboard($0)
      }
   }

   override func setupDefaults() {
      containerView.isHidden = true
   }

   func toggleEffect() {
      let component: AVAudioUnitComponent? = (audioUnit == nil) ? audioUnitComponent : nil
      viewModel.selectEffect(component) { [weak self] in
         if let au = $0.auAudioUnit as? AttenuatorAudioUnit {
            self?.openEffectView(au: au)
         }
      }
   }

   private func openEffectView(au: AttenuatorAudioUnit) {
      audioUnit = au
      let ctrl = AttenuatorViewController(au: au)
      ctrl.view.translatesAutoresizingMaskIntoConstraints = false
      addChild(ctrl)
      containerView.addSubview(ctrl.view)
      LayoutConstraint.pin(to: .bounds, ctrl.view).activate()
      audioUnitController = ctrl
      containerView.isHidden = false
   }

   private func closeEffectView() {
      containerView.isHidden = true
      audioUnit = nil
      audioUnitController?.view.removeFromSuperview()
      audioUnitController?.removeFromParent()
      audioUnitController = nil
   }
}
