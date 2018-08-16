//
//  AttenuatorView.swift
//  Attenuator
//
//  Created by Vlad Gorlov on 25.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AudioUnit
import Cocoa
import mcBase

class AttenuatorView: NSView {

   private (set) lazy var viewLevelMeter = VULevelMeter()
   private lazy var sliderGain = NSSlider()
   private lazy var stackView = NSStackView()
   private lazy var viewContainerView = NSView()

   private var displayLinkUtility: DisplayLink.GenericRenderer?

   var handlerParameterDidChaned: ((AttenuatorParameter, AUValue) -> Void)?
   var meterRefreshCallback: (() -> [AttenuatorDSPKernel.SampleType]?)?

   override init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      setupUI()
      setupLayout()
      setupHandlers()
   }

   required init?(coder decoder: NSCoder) {
      fatalError()
   }

   deinit {
      log.deinitialize()
   }

}

extension AttenuatorView {

   func updateParameter(parameter: AttenuatorParameter, withValue: AUValue) {
      sliderGain.floatValue = withValue
   }

   func startMetering() {
      do {
         try displayLinkUtility?.start()
      } catch {
         log.error(.media, error)
      }
   }

   func stopMetering() {
      do {
         try displayLinkUtility?.stop()
      } catch {
         log.error(.media, error)
      }
   }
}

extension AttenuatorView {

   private func setupHandlers() {
      sliderGain.target = self
      sliderGain.action = #selector(handleGainChange(_:))

      do {
         displayLinkUtility = try DisplayLink.GenericRenderer(frameRateDivider: 2, renderCallbackQueue: .main)
         displayLinkUtility?.renderCallback = { [weak self] in
            if let value = self?.meterRefreshCallback?() {
               self?.viewLevelMeter.level = value
            }
         }
      } catch {
         log.error(.media, error)
      }
   }

   private func setupUI() {

      addSubview(viewContainerView)

      autoresizingMask = [.width, .height]
      frame = CGRect(x: 0, y: 0, width: 320, height: 200)
      wantsLayer = true
      layer?.backgroundColor = CGColor(red: 0.6, green: 1, blue: 0.6, alpha: 1)

      viewContainerView.addSubview(stackView)
      viewContainerView.translatesAutoresizingMaskIntoConstraints = false

      stackView.addArrangedSubview(viewLevelMeter)
      stackView.addArrangedSubview(sliderGain)

      stackView.alignment = .leading
      stackView.detachesHiddenViews = true
      stackView.distribution = .fill
      stackView.orientation = .vertical
      stackView.translatesAutoresizingMaskIntoConstraints = false

//      sliderGain.alignment = .left
//      sliderGain.doubleValue = 50
      sliderGain.maxValue = 100
      sliderGain.numberOfTickMarks = 10
      sliderGain.setContentHuggingPriority(.defaultHigh, for: .vertical)
      sliderGain.sliderType = .linear
      sliderGain.tickMarkPosition = .above
      sliderGain.translatesAutoresizingMaskIntoConstraints = false

      sliderGain.cell?.isContinuous = true
//      sliderGain.cell?.state = .on

      viewLevelMeter.translatesAutoresizingMaskIntoConstraints = false
   }

   private func setupLayout() {
      var constraints: [NSLayoutConstraint] = []

      constraints += [
         bottomAnchor.constraint(equalTo: viewContainerView.bottomAnchor),
         trailingAnchor.constraint(equalTo: viewContainerView.trailingAnchor),
         viewContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
         viewContainerView.topAnchor.constraint(equalTo: topAnchor)
      ]

      constraints += [
         stackView.centerYAnchor.constraint(equalTo: viewContainerView.centerYAnchor),
         stackView.leadingAnchor.constraint(equalTo: viewContainerView.leadingAnchor, constant: 8),
         viewContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
         viewContainerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 8),
         viewContainerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 320)
      ]

      constraints += [
         viewLevelMeter.heightAnchor.constraint(equalToConstant: 22)
      ]

      NSLayoutConstraint.activate(constraints)
   }

   @objc private func handleGainChange(_ sender: NSSlider) {
      handlerParameterDidChaned?(AttenuatorParameter.gain, sender.floatValue)
   }
}
