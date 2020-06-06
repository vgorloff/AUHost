//
//  AVFileType.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 21.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import AVFoundation

extension AVFileType {

   public init(fileExtension: String) {
      switch fileExtension {
      case "mov", ".qt":
         self = .mov
      default:
         self = .mov // FIXME: Implement other cases.
      }
   }
}
