//
//  AudioComponentsUtility.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 6/25/15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import AVFoundation
import mcFoundationExtensions
import mcFoundationObservables

@available(OSX 10.11, *)
extension Notification.Name {
   static let audioComponentRegistrationsChanged = Notification.Name(rawValue:
      kAudioComponentRegistrationsChangedNotification as String)
   static let audioComponentInstanceInvalidation = Notification.Name(rawValue:
      kAudioComponentInstanceInvalidationNotification as String)
}

@available(iOS 9.0, OSX 10.11, *)
public final class AudioComponentsUtility {

   public enum StateChange {
      case audioComponentRegistered
      case audioComponentInstanceInvalidated(AUAudioUnit)
   }

   private var observerOfComponentChange: NotificationObserver?
   private var observerOfComponentInvalidate: NotificationObserver?
   private lazy var notificationsQueue = OperationQueue.parallel(qos: .utility)

   public var handlerStateChange: ((StateChange) -> Void)?
   public var completionHandlerQueue = DispatchQueue.main

   public init() {
      setUpObservers()
      log.initialize()
   }

   deinit {
      tearDownObservers()
      log.deinitialize()
   }

   /// **Note** Always calls completion handler on main queue
   /// - parameter queue: Queue used to query components.
   /// - parameter completion: Result completion handler.
   public func updateEffectList(queue: DispatchQueue = DispatchQueue.global(qos: .utility),
                                completion: @escaping ([AVAudioUnitComponent]) -> Void) {
      // Locating components can be a little slow, especially the first time.
      // Do this work on a separate dispatch thread.
      queue.async { [weak self] in guard let s = self else { return }
         var anyEffectDescription = AudioComponentDescription()
         anyEffectDescription.componentType = kAudioUnitType_Effect
         anyEffectDescription.componentSubType = 0
         anyEffectDescription.componentManufacturer = 0
         anyEffectDescription.componentFlags = 0
         anyEffectDescription.componentFlagsMask = 0
         let effects = AVAudioUnitComponentManager.shared().components(matching: anyEffectDescription)

         s.completionHandlerQueue.async {
            completion(effects)
         }
      }
   }

   // MARK: - Private

   private func setUpObservers() {
      observerOfComponentChange = NotificationObserver(name: .audioComponentRegistrationsChanged, queue: notificationsQueue) { [weak self] _ in
         guard let s1 = self else {
            return
         }
         s1.completionHandlerQueue.async { [weak s1] in
            guard let s2 = s1 else {
               return
            }
            s2.handlerStateChange?(.audioComponentRegistered)
         }
      }

      observerOfComponentChange = NotificationObserver(name: .audioComponentInstanceInvalidation, queue: notificationsQueue) { [weak self] notification in
         guard let this = self else {
            return
         }
         guard let crashedAU = notification.object as? AUAudioUnit else {
            fatalError()
         }
         this.completionHandlerQueue.async {
            self?.handlerStateChange?(.audioComponentInstanceInvalidated(crashedAU))
         }
      }
   }

   private func tearDownObservers() {
      observerOfComponentChange = nil
      observerOfComponentInvalidate = nil
   }
}
