//
//  Window.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09.02.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public class Window: UIWindow {

   override public init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = .white
   }

   public convenience init(frame: CGRect, rootViewController vc: UIViewController) {
      self.init(frame: frame)
      rootViewController = vc
   }

   public required init?(coder aDecoder: NSCoder) {
      fatalError()
   }
}
#endif
