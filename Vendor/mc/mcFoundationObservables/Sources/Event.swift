//
//  Event.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 13.02.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

// - SeeAlso: [ Implementing Events in Swift ]( http://blog.scottlogic.com/2015/02/05/swift-events.html )

public final class Event<T> {

   public typealias EventHandlerType = (T) -> Void

   fileprivate var _eventHandlers = [_EventHandler<T>]()

   public func raise(data: T) {
      for handler in _eventHandlers {
         handler.invoke(data: data)
      }
   }

   public func addHandler<I: Equatable>(identifier: I, handler: @escaping EventHandlerType) -> Disposable {
      let handler = _IDBasedEventHandler(event: self, identifier: identifier, handler: handler)
      _eventHandlers.append(handler)
      return handler
   }

   public func removeHandler<I: Equatable>(identifier anIdentifier: I) {
      _eventHandlers = _eventHandlers.filter { element in
         guard let eventHandler = element as? _IDBasedEventHandler<T, I> else {
            return true
         }
         return !(eventHandler.identifier == anIdentifier && eventHandler.event === self)
      }
   }

   public func addHandler<U: AnyObject>(target: U, _ handler: @escaping (U) -> EventHandlerType) -> Disposable {
      let handler = _TargetBasedEventHandler(event: self, target: target, handler: handler)
      _eventHandlers.append(handler)
      return handler
   }

   public func removeHandler<U: AnyObject>(target aTarget: U) {
      _eventHandlers = _eventHandlers.filter { element in
         guard let eventHandler = element as? _TargetBasedEventHandler<T, U>, let eventHandlerTarget = eventHandler.target else {
            return true
         }
         return !(eventHandlerTarget === aTarget && eventHandler.event === self)
      }
   }

   public func removeAllHandlers() {
      _eventHandlers.removeAll()
   }

   deinit {
      removeAllHandlers()
   }
}

// MARK: -

private class _EventHandler<T>: Disposable {
   private(set) var isDisposed: Bool = false
   unowned let event: Event<T>
   init(event anEvent: Event<T>) {
      event = anEvent
   }

   func invoke(data: T) {
      fatalError("Abstract method call")
   }

   func dispose() {
      event._eventHandlers = event._eventHandlers.filter { $0 !== self }
      isDisposed = true
   }

   deinit {
      dispose()
   }
}

private final class _TargetBasedEventHandler<T, U: AnyObject>: _EventHandler<T> {
   weak var target: U?
   let handler: (U) -> Event<T>.EventHandlerType

   init(event: Event<T>, target aTarget: U, handler aHandler: @escaping (U) -> Event<T>.EventHandlerType) {
      target = aTarget
      handler = aHandler
      super.init(event: event)
   }

   override func invoke(data: T) {
      if let t = target {
         handler(t)(data)
      }
   }
}

private final class _IDBasedEventHandler<T, I>: _EventHandler<T> {
   let identifier: I
   let handler: Event<T>.EventHandlerType

   init(event: Event<T>, identifier anID: I, handler aHandler: @escaping Event<T>.EventHandlerType) {
      identifier = anID
      handler = aHandler
      super.init(event: event)
   }

   override func invoke(data: T) {
      handler(data)
   }
}
