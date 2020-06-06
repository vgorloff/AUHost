//
//  StepTrigger.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 16.07.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct StepTrigger {

   public var callback: (() -> Void)?

   public let numberOfSteps: UInt
   public var currentStep: UInt {
      return currentStepValue
   }

   private var currentStepValue: UInt = 0

   public init(numberOfSteps: UInt) {
      self.numberOfSteps = numberOfSteps
   }

   public mutating func increment() {
      currentStepValue += 1
      if currentStepValue >= numberOfSteps {
         callback?()
         currentStepValue = 0
      }
   }
}
