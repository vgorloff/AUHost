//
//  AudioComponentsUtility.swift
//  WaveLabs
//
//  Created by User on 6/25/15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import AVFoundation

extension Notification.Name {
   static let audioComponentRegistrationsChanged = Notification.Name(rawValue:
      kAudioComponentRegistrationsChangedNotification as String)
   static let audioComponentInstanceInvalidation = Notification.Name(rawValue:
      kAudioComponentInstanceInvalidationNotification as String)
}

@available(iOS 9.0, *)
public final class AudioComponentsUtility {

   public enum StateChange {
      case audioComponentRegistered
      case audioComponentInstanceInvalidated(AUAudioUnit, AudioUnit?)
   }

   private var observerOfComponentChange: Notification.SmartObserver?
   private var observerOfComponentInvalidate: Notification.SmartObserver?
   private lazy var notificationsQueue = OperationQueue.Concurrent.utility()

   public var handlerStateChange: ((StateChange) -> Void)?
   public var completionHandlerQueue = DispatchQueue.main

   public init() {
      setUpObservers()
      Logger.initialize(subsystem: .media)
   }

   deinit {
      tearDownObservers()
      Logger.deinitialize(subsystem: .media)
   }

   /// **Note** Always calls completion handler on main queue
   /// - parameter queue: Queue used to query components.
   /// - parameter completion: Result completion handler.
   public func updateEffectList(queue: DispatchQueue = DispatchQueue.Utility,
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
      observerOfComponentChange = Notification.SmartObserver(
      forName: .audioComponentRegistrationsChanged, queue: notificationsQueue) { [weak self] _ in
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

      observerOfComponentChange = Notification.SmartObserver(
      forName: .audioComponentInstanceInvalidation, queue: notificationsQueue) {[weak self] notification in
         guard let s1 = self else {
            return
         }
         guard let crashedAU = notification.object as? AUAudioUnit else {
            fatalError()
         }
         var audioUnit: AudioUnit?
         if let value = notification.userInfo?["audioUnit"] as? NSValue {
            let pointer = unsafeBitCast(value.pointerValue, to: UnsafeMutablePointer<AudioUnit>.self)
            audioUnit = pointer.pointee
         }
         s1.completionHandlerQueue.async { [weak s1] in
            guard let s2 = s1 else {
               return
            }
            s2.handlerStateChange?(.audioComponentInstanceInvalidated(crashedAU, audioUnit))
         }
      }
   }

   private func tearDownObservers() {
      observerOfComponentChange = nil
      observerOfComponentInvalidate = nil
   }
}
