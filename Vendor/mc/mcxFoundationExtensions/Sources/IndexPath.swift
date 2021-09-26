//
//  IndexPath.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 05.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if os(OSX)
import AppKit
import mcxTypes

public class __IndexPathNext: InstanceHolder<IndexPath> {

   public var byItem: IndexPath {
      return IndexPath(item: instance.item + 1, section: instance.section)
   }
}

public class __IndexPathPrevious: InstanceHolder<IndexPath> {

   public var byItem: IndexPath {
      return IndexPath(item: instance.item - 1, section: instance.section)
   }
}

extension IndexPath {

   public var next: __IndexPathNext {
      return __IndexPathNext(instance: self)
   }

   public var previous: __IndexPathPrevious {
      return __IndexPathPrevious(instance: self)
   }
}
#endif
