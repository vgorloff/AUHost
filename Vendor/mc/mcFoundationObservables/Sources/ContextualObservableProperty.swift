//
//  ContextualObservableProperty.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public enum ObservablePropertyChangeKind {
   case New, Old, Initial
}

public struct ObservablePropertyObservingOption: OptionSet, CustomReflectable {
   public let rawValue: Int
   public init(rawValue aValue: Int) { rawValue = aValue }
   public static let Initial = ObservablePropertyObservingOption(rawValue: 1 << 0) // 1
   public static let New = ObservablePropertyObservingOption(rawValue: 1 << 1) // 2
   public static let Old = ObservablePropertyObservingOption(rawValue: 1 << 2) // 4
   public var customMirror: Mirror {
      let children = KeyValuePairs<String, Any>(dictionaryLiteral: ("Initial", contains(.Initial)),
                                                ("New", contains(.New)), ("Old", contains(.Old)))
      return Mirror(self, children: children)
   }
}

public final class ContextualObservableProperty<T> {

   public typealias EventType = (T, ObservablePropertyChangeKind, AnyObject?)
   private let onChange = ContextEvent<EventType, ObservablePropertyObservingOption>()
   private var sender: AnyObject?
   private var value: T {
      willSet {
         onChange.raise(data: (value, .Old, sender)) { options in
            options.contains(.Old)
         }
      }
      didSet {
         onChange.raise(data: (value, .New, sender)) { options in
            options.contains(.New)
         }
      }
   }

   public func addObserver(options: ObservablePropertyObservingOption = [.New],
                           handler: @escaping ((EventType) -> Void)) -> Disposable {
      let h = onChange.addHandler(context: options) { value, _ in
         handler(value)
      }
      onChange.raise(data: (value, .Initial, nil)) { options in
         options.contains(.Initial)
      }
      return h
   }

   public func addObserver<I: Equatable>(options: ObservablePropertyObservingOption = [.New], identifier: I,
                                         handler: @escaping ((EventType) -> Void)) -> Disposable {
      let h = onChange.addHandler(context: options, identifier: identifier) { value, _ in
         handler(value)
      }
      onChange.raise(data: (value, .Initial, nil)) { options in
         options.contains(.Initial)
      }
      return h
   }

   public func removeObserver<I: Equatable>(identifier: I) {
      onChange.removeHandler(identifier: identifier)
   }

   public init(_ initialValue: T) {
      value = initialValue
   }

   public func set(_ newValue: T, sender aSender: AnyObject? = nil) {
      sender = aSender
      value = newValue
      sender = nil
   }

   public func set(_ newValueOrNil: T?, sender aSender: AnyObject? = nil) {
      if let newValue = newValueOrNil {
         sender = aSender
         value = newValue
         sender = nil
      }
   }

   public func get() -> T {
      return value
   }

   deinit {
      onChange.removeAllHandlers()
   }
}
