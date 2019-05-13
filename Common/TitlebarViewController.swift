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

   enum Event: CaseIterable {
      case library, play, effect, reloadPlugIns
   }

   var eventHandler: ((Event) -> Void)?

   private lazy var actionsBar = ActionsBar().autolayoutView()
   private lazy var buttonLibrary = Button(image: ControlIcon.library.image).autolayoutView()
   private lazy var buttonPlay = Button(image: ControlIcon.play.image, alternateImage: ControlIcon.pause.image).autolayoutView()
   private lazy var buttonLoadAU = Button(image: ControlIcon.effect.image).autolayoutView()
   private lazy var buttonReload = Button(image: ControlIcon.reload.image).autolayoutView()

   private let isHostTitleBar: Bool

   init(isHostTitleBar: Bool) {
      self.isHostTitleBar = isHostTitleBar
      super.init()
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   override func setupUI() {
      view.addSubviews(actionsBar)

      let spacing: CGFloat = 7

      actionsBar.itemsSpacing = spacing
      actionsBar.edgeInsets = EdgeInsets(horizontal: spacing, vertical: 3)
      actionsBar.setLeftItems(buttonPlay, buttonLoadAU)
      isHostTitleBar ? actionsBar.setRightItems(buttonReload, buttonLibrary) : actionsBar.setRightItems(buttonLibrary)

      buttonPlay.setButtonType(.toggle)

      buttonReload.toolTip = "Reload PlugIns"
      buttonLibrary.toolTip = "Toggle Media Library"
      buttonPlay.toolTip = "Toggle Playback"
      buttonLoadAU.toolTip = isHostTitleBar ? "Show Effect Window" : "Load / Unload Effect"
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
      buttonReload.setHandler { [weak self] in
         self?.eventHandler?(.reloadPlugIns)
      }
   }

   func handleEvent(_ event: MainViewUIModel.Event, _ state: MainViewUIModel.State) {
      switch event {
      case .playbackEngineStageChanged(let playbackState):
         buttonLoadAU.isEnabled = state.contains(.canOpenEffect)
         switch playbackState {
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
            buttonLoadAU.isEnabled = false
         }
      case .loadingEffects(let isBusy):
         buttonLoadAU.isEnabled = !isBusy && state.contains(.canOpenEffect)
      default:
         buttonLoadAU.isEnabled = state.contains(.canOpenEffect)
      }
      if !isHostTitleBar {
         buttonLoadAU.isEnabled = true
      }
   }
}
