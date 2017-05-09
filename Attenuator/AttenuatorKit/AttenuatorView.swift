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
      do {
         displayLinkUtility = try DisplayLink.GenericRenderer(frameRateDivider: 2, renderCallbackQueue: DispatchQueue.main)
         displayLinkUtility?.renderCallback = { [weak self] in
            if let value = self?.meterRefreshCallback?() {
               self?.viewLevelMeter.level = value
            }
         }
      } catch {
         Swift.print(error)
      }

      wantsLayer = true
      layer?.backgroundColor = CGColor(red: 0.6, green: 1, blue: 0.6, alpha: 1)
   }

   func updateParameter(parameter: AttenuatorParameter, withValue: AUValue) {
      sliderGain.floatValue = withValue
   }

   @IBAction private func handleGainChange(_ sender: NSSlider) {
      handlerParameterDidChaned?(AttenuatorParameter.gain, sender.floatValue)
   }

   func startMetering() {
      do {
         try displayLinkUtility?.start()
      } catch {
         Swift.print(error)
      }
   }

   func stopMetering() {
      do {
         try displayLinkUtility?.stop()
      } catch {
         Swift.print(error)
      }
   }
}
