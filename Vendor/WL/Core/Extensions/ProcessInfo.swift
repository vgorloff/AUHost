//
//  ProcessInfo.swift
//  mcCore
//
//  Created by Vlad Gorlov on 25.10.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public extension ProcessInfo {

   public static var executableFilePath: String {
      return ProcessInfo.processInfo.arguments[0]
   }

   public static var executableFileName: String {
      return (executableFilePath as NSString).lastPathComponent
   }

   public static var executableDirectoryPath: String {
      return (executableFilePath as NSString).deletingLastPathComponent
   }
}
