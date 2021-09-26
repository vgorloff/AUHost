//
//  FileHandle.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 29.06.18.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension FileHandle {

   /// See: https://stackoverflow.com/questions/7505777/how-do-i-check-for-nsfilehandle-has-data-available?rq=1
   public var isReadable: Bool {
      var fdset = fd_set()
      FileDescriptor.fdZero(&fdset)
      FileDescriptor.fdSet(fileDescriptor, set: &fdset)
      var tmout = timeval()
      let status = select(fileDescriptor + 1, &fdset, nil, nil, &tmout)
      return status > 0
   }
}
