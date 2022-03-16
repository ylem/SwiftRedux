//
//  File.swift
//  
//
//  Created by Wei Lu on 22/09/2021.
//

import Foundation
import Combine
import SwiftUI

public class Store<State, Action, Environment>: ObservableObject {

    @Published private(set) public var state: State

    private let reducer: Reducer<State, Action>
    private let middlewares: [Middleware<State, Action, Environment>]
    private let queue: DispatchQueue
    public var subscriptions: Set<AnyCancellable> = []

    private(set) public var environment: Environment

    public init(
        initial: State,
        reducer: @escaping Reducer<State, Action>,
        environment: Environment,
        middlewares: [Middleware<State, Action, Environment>] = [],
        queue: DispatchQueue = .init(label: "com.myjlr.store", qos: .userInitiated)
    ) {
        self.state = initial
        self.reducer = reducer
        self.environment = environment
        self.middlewares = middlewares
        self.queue = queue
    }

    public func dispatch(_ action: Action) {
        queue.sync {
            self.dispatch(self.state, action)
        }
    }

    private func dispatch(_ currentState: State, _ action: Action) {
        let newState = reducer(currentState, action)

        middlewares.forEach { middleware in
            let publisher = middleware(newState, action, environment)
            publisher
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in },
                      receiveValue: dispatch )
                .store(in: &subscriptions)
        }

        state = newState
    }
}
