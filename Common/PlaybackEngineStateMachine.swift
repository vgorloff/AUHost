//
//  PlaybackEngineStateMachine.swift
//  AUHost
//
//  Created by VG (DE) on 16.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation
import CoreAudioKit
import AVFoundation

struct PlaybackEngineStateMachine {

   typealias GraphType = StateMachineGraph<State, Event, PlaybackEngineContext>

   enum State: Int {
      case Stopped, Playing, Paused, SettingFile, SettingEffect
      var stringValue: String {
         switch self {
         case .Stopped: return "Stopped"
         case .Playing: return "Playing"
         case .Paused: return "Paused"
         case .SettingFile: return "SettingFile"
         case .SettingEffect: return "SettingEffect"
         }
      }
   }

   enum Event {
      case Play, Pause, Resume, Stop
      case SetFile(AVAudioFile?)
      case SetEffect(AudioComponentDescription?, ((EffectSelectionResult) -> Void))
      var intValue: Int {
         switch self {
         case .Play: return 0
         case .Pause: return 1
         case .Resume: return 2
         case .Stop: return 3
         case .SetEffect: return 4
         case .SetFile: return 5
         }
      }
   }

   enum EffectSelectionResult {
      case EffectCleared
      case Success(AVAudioUnit)
      case Failure(Error)
   }

   static let stateMachineGraph = GraphType(initialState: .Stopped) {
      let (state, event) = $0
      switch state {
      case .Stopped:
         switch event {
         case .Play:
            return (.Playing, { try $0.play() })
         case .SetFile(let file):
            return (.SettingFile, { $0.setFileToPlay(file) })
         case .SetEffect(let component, let callback):
            return (.SettingEffect, { ctx in ctx.selectEffect(componentDescription: component, completionHandler: callback) })
         case .Pause, .Resume, .Stop:
            return nil
         }
      case .Playing:
         switch event {
         case .Pause:
            return (.Paused, { $0.pause() })
         case .Stop:
            return (.Stopped, { $0.stop() })
         case .SetFile, .Play, .Resume:
            return nil
         case .SetEffect(let component, let callback):
            return (.SettingEffect, {
               $0.stopPlayer()
               $0.selectEffect(componentDescription: component, completionHandler: callback)
            })
         }
      case .Paused:
         switch event {
         case .Resume:
            return (.Playing, { try $0.resume() })
         case .Stop:
            return (.Stopped, { $0.stop() })
         case .SetFile, .Play, .Pause:
            return nil
         case .SetEffect(let component, let callback):
            return (.SettingEffect, {
               $0.stopPlayer()
               $0.selectEffect(componentDescription: component, completionHandler: callback)
            })
         }
      case .SettingEffect:
         switch event {
         case .SetEffect, .SetFile, .Resume:
            return nil
         case .Stop:
            return (.Stopped, nil)
         case .Play:
            return (.Playing, { try $0.startPlayer() })
         case .Pause:
            return (.Paused, { try $0.scheduleFile() })
         }
      case .SettingFile:
         switch event {
         case .SetEffect, .SetFile, .Resume, .Play, .Pause:
            return nil
         case .Stop:
            return (.Stopped, nil)
         }
      }
   }
}
