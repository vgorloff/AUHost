//
//  PopUpButton.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 05.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class PopUpButton: NSPopUpButton {

   public init(pullsDown: Bool = false) {
      super.init(frame: .zero, pullsDown: pullsDown)
      translatesAutoresizingMaskIntoConstraints = false
   }

   override public init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      translatesAutoresizingMaskIntoConstraints = false
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }
}
#endif
