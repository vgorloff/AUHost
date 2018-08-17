//
//  MainViewController.swift
//  Attenuator
//
//  Created by Volodymyr Gorlov on 14.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AVFoundation
import Cocoa

class MainViewController: NSViewController {

   private lazy var stackView1 = NSStackView()
   private lazy var stackView2 = NSStackView()

   private lazy var buttonPlay = NSButton()
   private lazy var buttonLoadAU = NSButton()
   private lazy var mediaItemView = MediaItemView()
   private lazy var containerView = NSView()

   private var audioUnit: AttenuatorAudioUnit?
   private var audioUnitController: AttenuatorViewController?
   private var audioUnitComponent: AVAudioUnitComponent?

   override func loadView() {
      view = NSView()
   }

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

   init() {
      super.init(nibName: nil, bundle: nil)
      AUAudioUnit.registerSubclass(AttenuatorAudioUnit.self, as: acd, name: "WaveLabs: Attenuator (Local)", version: version)
      let registeredComponents = AVAudioUnitComponentManager.shared().components(matching: acd)
      audioUnitComponent = registeredComponents.first
   }

   required init?(coder: NSCoder) {
      fatalError("Please use this class from code.")
   }

   override func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
      setupLayout()
      setupHandlers()
   }
}

extension MainViewController {

   func handleEvent(_ event: MainViewUIModel.Event) {
      switch event {
      case .playbackEngineStageChanged(let state):
         switch state {
         case .playing:
            buttonPlay.isEnabled = true
            buttonPlay.title = "Pause"
         case .stopped:
            buttonPlay.isEnabled = true
            buttonPlay.title = "Play"
         case .paused:
            buttonPlay.isEnabled = true
            buttonPlay.title = "Resume"
         case .updatingGraph:
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

extension MainViewController {

   private func setupUI() {

      view.addSubview(stackView1)

      stackView1.addArrangedSubview(stackView2)
      stackView1.addArrangedSubview(mediaItemView)
      stackView1.addArrangedSubview(containerView)
      stackView1.alignment = .centerX
      stackView1.detachesHiddenViews = true
      stackView1.distribution = .fillProportionally
      stackView1.orientation = .vertical
      stackView1.setHuggingPriority(NSLayoutConstraint.Priority(rawValue: 249.99998474121094), for: .horizontal)
      stackView1.setHuggingPriority(NSLayoutConstraint.Priority(rawValue: 249.99998474121094), for: .vertical)
      stackView1.translatesAutoresizingMaskIntoConstraints = false

      containerView.translatesAutoresizingMaskIntoConstraints = false

      mediaItemView.translatesAutoresizingMaskIntoConstraints = false

      stackView2.addArrangedSubview(buttonPlay)
      stackView2.addArrangedSubview(buttonLoadAU)
      stackView2.alignment = .centerY
      stackView2.detachesHiddenViews = true
      stackView2.distribution = .fillEqually
      stackView2.setHuggingPriority(NSLayoutConstraint.Priority(rawValue: 249.99998474121094), for: .horizontal)
      stackView2.setHuggingPriority(NSLayoutConstraint.Priority(rawValue: 249.99998474121094), for: .vertical)
      stackView2.translatesAutoresizingMaskIntoConstraints = false

      buttonLoadAU.alignment = .center
      buttonLoadAU.bezelStyle = .rounded
      buttonLoadAU.font = NSFont.systemFont(ofSize: 13)
      buttonLoadAU.imageScaling = .scaleProportionallyDown
      buttonLoadAU.setContentHuggingPriority(.defaultHigh, for: .vertical)
      buttonLoadAU.title = "Load AU"
      buttonLoadAU.translatesAutoresizingMaskIntoConstraints = false
      buttonLoadAU.cell?.isBordered = true

      buttonPlay.isEnabled = false
      buttonPlay.alignment = .center
      buttonPlay.bezelStyle = .rounded
      buttonPlay.font = NSFont.systemFont(ofSize: 13)
      buttonPlay.imageScaling = .scaleProportionallyDown
      buttonPlay.setContentHuggingPriority(.defaultHigh, for: .vertical)
      buttonPlay.title = "Play"
      buttonPlay.translatesAutoresizingMaskIntoConstraints = false
      buttonPlay.cell?.isBordered = true
   }

   private func setupLayout() {

      var constraints: [NSLayoutConstraint] = []

      constraints += [
         stackView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
         stackView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
         view.bottomAnchor.constraint(equalTo: stackView1.bottomAnchor, constant: 10),
         view.trailingAnchor.constraint(equalTo: stackView1.trailingAnchor, constant: 10)
      ]

      constraints += [
         mediaItemView.heightAnchor.constraint(equalToConstant: 120),
         stackView2.widthAnchor.constraint(equalToConstant: 196)
      ]

      NSLayoutConstraint.activate(constraints)
   }

   private func setupHandlers() {
      mediaItemView.onCompleteDragWithObjects = { [weak self] in
         self?.viewModel.handlePastboard($0)
      }
      viewModel.eventHandler = { [weak self] in
         self?.handleEvent($0)
      }
      buttonPlay.target = self
      buttonPlay.action = #selector(actionTogglePlayAudio(_:))

      buttonLoadAU.target = self
      buttonLoadAU.action = #selector(actionToggleEffect(_:))
   }

   @objc private func actionToggleEffect(_: AnyObject) {
      let component: AVAudioUnitComponent? = (audioUnit == nil) ? audioUnitComponent : nil
      viewModel.selectEffect(component) { [weak self] in
         if let au = $0.auAudioUnit as? AttenuatorAudioUnit {
            self?.openEffectView(au: au)
         }
      }
   }

   @objc private func actionTogglePlayAudio(_: AnyObject) {
      viewModel.togglePlay()
   }

   private func openEffectView(au: AttenuatorAudioUnit) {
      audioUnit = au
      let ctrl = AttenuatorViewController(au: au)
      ctrl.view.translatesAutoresizingMaskIntoConstraints = false
      addChildViewController(ctrl)
      containerView.addSubview(ctrl.view)
      let cH = NSLayoutConstraint.constraints(withVisualFormat: "|[subview]|",
                                              options: [], metrics: nil, views: ["subview": ctrl.view])
      let cV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[subview]|",
                                              options: [], metrics: nil, views: ["subview": ctrl.view])
      NSLayoutConstraint.activate(cH + cV)
      audioUnitController = ctrl
   }

   private func closeEffectView() {
      audioUnit = nil
      audioUnitController?.view.removeFromSuperview()
      audioUnitController?.removeFromParentViewController()
      audioUnitController = nil
   }
}
