//
//  TitlebarViewController.swift
//  Attenuator
//
//  Created by Vlad Gorlov on 13.10.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import Foundation
import AppKit

class TitlebarViewController: ViewController {

   enum Event {
      case library, play, effect
   }

   var eventHandler: ((Event) -> Void)?

   private lazy var buttonsStackView = StackView().autolayoutView()
   private lazy var buttonLibrary = Button(title: "Library").autolayoutView()
   private lazy var buttonPlay = Button(title: "Play").autolayoutView()
   private lazy var buttonLoadAU = Button(title: "Load AU").autolayoutView()

   override func setupUI() {
      view.addSubviews(buttonsStackView)

      buttonsStackView.addArrangedSubviews(buttonPlay, buttonLoadAU, buttonLibrary)
      buttonsStackView.distribution = .fillProportionally
      buttonsStackView.spacing = 7
   }

   override func setupDefaults() {
      buttonPlay.isEnabled = false
   }

   override func setupLayout() {
      LayoutConstraint.pin(to: .vertically, buttonsStackView).activate()
      LayoutConstraint.withFormat("|-7-[*]-(>=7)-|", buttonsStackView).activate()
   }

   override func setupHandlers() {
      buttonLibrary.setHandler { [weak self] in
         self?.eventHandler?(.library)
      }
      buttonPlay.setHandler { [weak self] in
         self?.eventHandler?(.play)
      }
      buttonLoadAU.setHandler { [weak self] in
         self?.eventHandler?(.effect)
      }
   }

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
      case .didSelectEffect(let error):
         if error == nil {
            buttonLoadAU.title = "Unload AU"
         }

      case .didClearEffect:
         buttonLoadAU.title = "Load AU"
      default:
         break
      }
   }
}
