//
//  BuildPhase_CheckHeaders.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09.11.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

if ProcessInfo.processInfo.arguments.count < 3 {
   print("Usage: ProjectName1;ProjectName2 Path1 Path2 ...")
   exit(0)
}

let projectNames = ProcessInfo.processInfo.arguments[1].components(separatedBy: ";").map {
   $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
}
let filesToAnalyze = ProcessInfo.processInfo.arguments[2..<ProcessInfo.processInfo.arguments.count]

do {
let checker = FileHeaderChecker(projectNames: projectNames)
   for fileToAnalyze in filesToAnalyze {
      let results = try checker.performAnalysis(fileOrDirectoryPath: fileToAnalyze)
      for result in results {
         print("\(result.filePath):1: warning: \(result.issueReason)")
      }
   }
} catch {
   print("Error: \(error)")
}
