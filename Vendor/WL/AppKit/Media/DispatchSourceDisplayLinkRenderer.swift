//
//  DispatchSourceDisplayLinkRenderer.swift
//  mcBase-macOS
//
//  Created by Vlad Gorlov on 19.08.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import Foundation
import mcCore
import mcConcurrency

public class DispatchSourceDisplayLinkRenderer: GenericDisplayLinkRenderer {

   private var callback: RenderCallback?

   private let dispatchSource: SmartDispatchSourceUserDataAdd

   public init(frameRateDivider divider: UInt = 1, renderCallbackQueue: DispatchQueue? = nil) throws {
      dispatchSource = SmartDispatchSourceUserDataAdd(queue: renderCallbackQueue)
      try super.init(frameRateDivider: divider)
      setupHandlers()
   }

   public override func start(shouldResetFrameCounter: Bool = false) throws {
      try super.start(shouldResetFrameCounter: shouldResetFrameCounter)
      dispatchSource.resume()
   }

   public override func stop() throws {
      try super.stop()
      dispatchSource.suspend()
   }

   public override func setCallback(_ callback: RenderCallback?) {
      self.callback = callback
   }
}

extension DispatchSourceDisplayLinkRenderer {

   private func setupHandlers() {
      super.setCallback { [weak self] in
         self?.dispatchSource.mergeData(value: 1)
      }
      dispatchSource.setEventHandler { [weak self] in
         self?.callback?()
      }
   }
}
