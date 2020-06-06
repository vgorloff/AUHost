//
//  Prompt.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct Prompt {

   let question: String?

   public init(question: String? = nil) {
      self.question = question
   }

   public func prompt() -> String? {
      askQuestion(choices: [])
      return readInput()
   }

   public func prompt(choices: [String]) -> Int? {
      askQuestion(choices: choices)
      guard let string = readInput(), let index = Scanner(string: string).mc.scanInt() else {
         return nil
      }
      let result = index - 1
      guard choices.indices.contains(result) else {
         return nil
      }
      return result
   }

   // MARK: -

   private func askQuestion(choices: [String]) {
      if let question = question {
         print(question)
      }
      for (index, choice) in choices.enumerated() {
         print("\(index + 1): \(choice)")
      }
      print("> ", terminator: "")
      fflush(stdout) // See also: https://stackoverflow.com/a/47718189/1418981
   }

   private func readInput() -> String? {
      let inputData = FileHandle.standardInput.availableData
      guard let string = String(data: inputData, encoding: .utf8) else {
         return nil
      }
      return string.trimmingCharacters(in: .whitespacesAndNewlines)
   }
}
