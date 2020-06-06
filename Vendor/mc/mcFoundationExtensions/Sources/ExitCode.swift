//
//  ExitCode.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 29.01.19.
//  Copyright © 2019 Vlad Gorlov. All rights reserved.
//

import Foundation

public func exit(_ code: ExitCode) -> Never {
   exit(code.status)
}

public func exit(_ status: Bool) -> Never {
   exit(status ? 0 : 1)
}

public enum ExitCode: Equatable {

   case success, failure, status(Int32)

   public init(status: Int32) {
      if status == ExitCode.failure.status {
         self = .failure
      } else if status == ExitCode.success.status {
         self = .success
      } else {
         self = .status(status)
      }
   }

   public var status: Int32 {
      switch self {
      case .success:
         return EXIT_SUCCESS
      case .failure:
         return EXIT_FAILURE
      case .status(let status):
         return status
      }
   }

   public static func == (lhs: ExitCode, rhs: ExitCode) -> Bool {
      return lhs.status == rhs.status
   }
}
