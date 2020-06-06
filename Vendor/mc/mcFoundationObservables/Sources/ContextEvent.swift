//
//  ContextEvent.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 15.02.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

public final class ContextEvent<T, C> {

   public typealias EventHandlerType = (T, C) -> Void

   fileprivate var _eventHandlers = [_ContextEventHandler<T, C>]()

   public func raise(data: T, condition: (C) -> Bool) {
      for handler in _eventHandlers {
         if condition(handler.context) {
            handler.invoke(data: data)
         }
      }
   }

   public func addHandler(context: C, handler: @escaping EventHandlerType) -> Disposable {
      let handler = _GenericContextEventHandler(event: self, context: context, handler: handler)
      _eventHandlers.append(handler)
      return handler
   }

   public func addHandler<I: Equatable>(context: C, identifier: I, handler: @escaping EventHandlerType) -> Disposable {
      let handler = _IDBasedContextEventHandler(event: self, context: context, identifier: identifier, handler: handler)
      _eventHandlers.append(handler)
      return handler
   }

   public func removeHandler<I: Equatable>(identifier anIdentifier: I) {
      _eventHandlers = _eventHandlers.filter { element in
         guard let eventHandler = element as? _IDBasedContextEventHandler<T, C, I> else {
            return true
         }
         return !(eventHandler.identifier == anIdentifier && eventHandler.event === self)
      }
   }

   public func addHandler<U: AnyObject>(context: C, target: U, _ handler: @escaping (U) -> EventHandlerType) -> Disposable {
      let handler = _TargetBasedContextEventHandler(event: self, context: context, target: target, handler: handler)
      _eventHandlers.append(handler)
      return handler
   }

   public func removeHandler<U: AnyObject>(target aTarget: U) {
      _eventHandlers = _eventHandlers.filter { element in
         guard let eventHandler = element as? _TargetBasedContextEventHandler<T, C, U>,
            let eventHandlerTarget = eventHandler.target else {
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

private class _ContextEventHandler<T, C>: Disposable {
   private(set) var isDisposed: Bool = false

   let context: C
   unowned let event: ContextEvent<T, C>
   init(event anEvent: ContextEvent<T, C>, context aContext: C) {
      event = anEvent
      context = aContext
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

private final class _TargetBasedContextEventHandler<T, C, U: AnyObject>: _ContextEventHandler<T, C> {
   weak var target: U?
   let handler: (U) -> ContextEvent<T, C>.EventHandlerType

   init(event: ContextEvent<T, C>, context: C, target aTarget: U, handler aHandler: @escaping (U) -> ContextEvent<T, C>.EventHandlerType) {
      target = aTarget
      handler = aHandler
      super.init(event: event, context: context)
   }

   override func invoke(data: T) {
      if let t = target {
         handler(t)(data, context)
      }
   }
}

private final class _IDBasedContextEventHandler<T, C, I>: _ContextEventHandler<T, C> {
   let identifier: I
   let handler: ContextEvent<T, C>.EventHandlerType

   init(event: ContextEvent<T, C>, context: C, identifier anID: I, handler aHandler: @escaping ContextEvent<T, C>.EventHandlerType) {
      identifier = anID
      handler = aHandler
      super.init(event: event, context: context)
   }

   override func invoke(data: T) {
      handler(data, context)
   }
}

private final class _GenericContextEventHandler<T, C>: _ContextEventHandler<T, C> {
   let handler: ContextEvent<T, C>.EventHandlerType

   init(event: ContextEvent<T, C>, context: C, handler aHandler: @escaping ContextEvent<T, C>.EventHandlerType) {
      handler = aHandler
      super.init(event: event, context: context)
   }

   override func invoke(data: T) {
      handler(data, context)
   }
}
