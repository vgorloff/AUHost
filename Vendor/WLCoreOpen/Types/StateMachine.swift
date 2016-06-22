//!  StateMachine.swift
//!  SwiftyStateMachine (https://github.com/macoscope/SwiftyStateMachine/blob/develop/StateMachine/StateMachine.swift)
//!  Published under the MIT License. Copyright (c) 2015 Macoscope sp. z o.o.
//!  This version of original source by Macoscope sp. z o.o. was modified by Vlad Gorlov on 16.01.16.

public protocol StateMachineGraphType {
	associatedtype State
	associatedtype Event
	associatedtype Context
	var initialState: State { get }
	var transitionGraph: (State, Event) -> (State, (Context throws -> Void)?)? { get }
	init(initialState: State, transitionGraph: (State, Event) -> (State, (Context throws -> Void)?)?)
}

public struct StateMachineGraph<State, Event, Context>: StateMachineGraphType {
	public let initialState: State
	public let transitionGraph: (State, Event) -> (State, (Context throws -> Void)?)?
	public init(initialState aInitialState: State,
		transitionGraph aTransitionGraph: (State, Event) -> (State, (Context throws -> Void)?)?) {
		initialState = aInitialState
		transitionGraph = aTransitionGraph
	}
}

/// - SeeAlso:
/// * [ Macoscope Blog | Introducing SwiftyStateMachine ]( http://macoscope.com/blog/swifty-state-machine/ )
/// * [ Finite-state machine - Wikipedia, the free encyclopedia ]( https://en.wikipedia.org/wiki/Finite-state_machine )
public struct StateMachine<T: StateMachineGraphType> {
	private let context: T.Context
	private let graph: T
	public private(set) var state: T.State
	public var stateChangeHandler: ((old: T.State, event: T.Event, new: T.State) -> ())?
	public init(context aContext: T.Context, graph aGraph: T) {
		context = aContext
		graph = aGraph
		state = aGraph.initialState
	}
	public mutating func handleEvent(event: T.Event) throws {
		if let (newState, transition) = graph.transitionGraph(state, event) {
			let oldState = state
			state = newState
			try transition?(context)
			stateChangeHandler?(old: oldState, event: event, new: newState)
		} else {
			fatalError("Unable to process event \"\(event)\" for state \"\(state)\"")
		}
	}
}
