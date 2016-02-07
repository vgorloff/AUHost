//
//  NSPipe.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 12.11.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

public extension NSPipe {

   public func readIntoString() -> String? {
      let data = fileHandleForReading.readDataToEndOfFile()
      if data.length > 0 {
         if let s = NSString(data: data, encoding: NSUTF8StringEncoding) {
            return s.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
         }
      }
      return nil
   }

}
