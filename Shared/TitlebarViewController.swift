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

   private lazy var actionsBar = ActionsBar().autolayoutView()
   private lazy var buttonLibrary = Button(image: ControlIcon.library.image).autolayoutView()
   private lazy var buttonPlay = Button(image: ControlIcon.play.image, alternateImage: ControlIcon.pause.image).autolayoutView()
   private lazy var buttonLoadAU = Button(image: ControlIcon.effect.image).autolayoutView()

   override func setupUI() {
      view.addSubviews(actionsBar)

      let spacing: CGFloat = 7

      actionsBar.itemsSpacing = spacing
      actionsBar.edgeInsets = EdgeInsets(horizontal: spacing, vertical: 3)
      actionsBar.setLeftItems(buttonPlay, buttonLoadAU)
      actionsBar.setRightItems(buttonLibrary)

      buttonPlay.setButtonType(.toggle)
   }

   override func setupDefaults() {
      buttonPlay.isEnabled = false
   }

   override func setupLayout() {
      LayoutConstraint.pin(to: .bounds, actionsBar).activate()
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
            buttonPlay.state = .on
         case .stopped:
            buttonPlay.isEnabled = true
            buttonPlay.state = .off
         case .paused:
            buttonPlay.isEnabled = true
            buttonPlay.state = .off
         case .updatingGraph:
            buttonPlay.isEnabled = false
         }
      default:
         break
      }
   }
}
