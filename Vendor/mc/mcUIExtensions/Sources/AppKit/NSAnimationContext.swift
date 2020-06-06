//
//  NSAnimationContext.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes

public class __NSAnimationContextImplicitAnimations: InstanceHolder<NSAnimationContext.Type> {
   public func run(duration: TimeInterval = 0.3, animations: () -> Void) {
      instance.runAnimationGroup({
         $0.duration = duration
         $0.allowsImplicitAnimation = true
         animations()
      }, completionHandler: nil)
   }

   public func run(duration: TimeInterval = 0.3, animations: () -> Void, completion: @escaping () -> Void) {
      instance.runAnimationGroup({
         $0.duration = duration
         $0.allowsImplicitAnimation = true
         animations()
      }, completionHandler: completion)
   }

   public func run(animations: () -> Void, completion: @escaping () -> Void) {
      instance.runAnimationGroup({
         $0.allowsImplicitAnimation = true
         animations()
      }, completionHandler: completion)
   }

   public func run(animations: () -> Void) {
      instance.runAnimationGroup({
         $0.allowsImplicitAnimation = true
         animations()
      }, completionHandler: nil)
   }
}

extension NSAnimationContext {

   public static var implicit: __NSAnimationContextImplicitAnimations {
      return __NSAnimationContextImplicitAnimations(instance: self)
   }

   public static func runAnimationGroup(animations: () -> Void) {
      runAnimationGroup({ _ in
         animations()
      }, completionHandler: nil)
   }
}
#endif
