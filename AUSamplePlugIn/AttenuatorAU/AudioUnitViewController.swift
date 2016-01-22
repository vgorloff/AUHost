//
//  AudioUnitViewController.swift
//  AttenuatorAU
//
//  Created by Volodymyr Gorlov on 14.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreAudioKit
import AVFoundation

public class AudioUnitViewController: AUViewController, AUAudioUnitFactory {
    var audioUnit: AUAudioUnit!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if audioUnit == nil {
            return
        }
        
        // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the AudioUnit
    }
    
    public func createAudioUnitWithComponentDescription(componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        audioUnit = try AttenuatorAudioUnit(componentDescription: componentDescription, options: [])
        return audioUnit
    }
    
}
