//
//  AttenuatorView.swift
//  Attenuator
//
//  Created by Vlad Gorlov on 25.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Cocoa
import AudioUnit

class AttenuatorView: NSView {

   @IBOutlet private weak var sliderGain: NSSlider!
   @IBOutlet private(set) weak var viewLevelMeter: VULevelMeter!

   private var displayLinkUtility: DisplayLink.GenericRenderer?

   var handlerParameterDidChaned: ((AttenuatorParameter, AUValue) -> Void)?
   var meterRefreshCallback: ((Void) -> [AttenuatorDSPKernel.SampleType]?)?

   override func awakeFromNib() {
      super.awakeFromNib()
      displayLinkUtility = g.perform(try DisplayLink.GenericRenderer(frameRateDivider: 60/10)) {
         Swift.print($0)
      }
      displayLinkUtility?.renderCallback = { [weak self] in
         if let value = self?.meterRefreshCallback?() {
            self?.viewLevelMeter.level = value
         }
      }
   }

   func updateParameter(parameter: AttenuatorParameter, withValue: AUValue) {
      sliderGain.floatValue = withValue
   }

   @IBAction private func handleGainChange(_ sender: NSSlider) {
      handlerParameterDidChaned?(AttenuatorParameter.Gain, sender.floatValue)
   }

   func startMetering() {
      _ = g.perform (try displayLinkUtility?.start()) {
         Swift.print($0)
      }
   }

   func stopMetering() {
      _ = g.perform (try displayLinkUtility?.stop()) {
         Swift.print($0)
      }
   }
}
