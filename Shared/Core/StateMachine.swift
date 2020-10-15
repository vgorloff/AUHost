//!  StateMachine.swift
//!  SwiftyStateMachine (https://github.com/macoscope/SwiftyStateMachine/blob/develop/StateMachine/StateMachine.swift)
//!  Published under the MIT License. Copyright (c) 2015 Macoscope sp. z o.o.
//!  This version of original source by Macoscope sp. z o.o. was modified by Vlad Gorlov on 16.01.16.

public protocol StateMachineGraphType {
   associatedtype State
   associatedtype Event
   associatedtype Context
   var initialState: State { get }
   var transitionGraph: (State, Event) -> (State, ((Context) throws -> Void)?)? { get }
   init(initialState: State, transitionGraph: @escaping (State, Event) -> (State, ((Context) throws -> Void)?)?)
}

public struct StateMachineGraph<State, Event, Context>: StateMachineGraphType {
   public var transitionGraph: (State, Event) -> (State, ((Context) throws -> Void)?)?
   public init(initialState: State, transitionGraph: @escaping (State, Event) -> (State, ((Context) throws -> Void)?)?) {
      self.initialState = initialState
      self.transitionGraph = transitionGraph
   }
   public typealias Action = (Context) throws -> Void
   public typealias Request = (State, Event)
   public typealias Response = (State, Action?)
   public let initialState: State
   
}

/// - SeeAlso:
/// * [ Macoscope Blog | Introducing SwiftyStateMachine ]( http://macoscope.com/blog/swifty-state-machine/ )
/// * [ Finite-state machine - Wikipedia, the free encyclopedia ]( https://en.wikipedia.org/wiki/Finite-state_machine )
public struct StateMachine<T: StateMachineGraphType> {
   private let context: T.Context
   private let graph: T
   public typealias OldState = T.State
   public typealias NewState = T.State
   public private(set) var state: T.State
   public var stateChangeHandler: ((OldState, T.Event, NewState) -> Void)?
   public init(context: T.Context, graph: T) {
      self.context = context
      self.graph = graph
      self.state = graph.initialState
   }
   public mutating func handleEvent(event: T.Event) throws {
      if let (newState, transition) = graph.transitionGraph(state, event) {
         let oldState = state
         state = newState
         try transition?(context)
         stateChangeHandler?(oldState, event, newState)
      } else {
         fatalError("Unable to process event \"\(event)\" for state \"\(state)\"")
      }
   }
}
