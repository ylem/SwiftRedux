//
//  File.swift
//  
//
//  Created by Wei Lu on 22/09/2021.
//

import Foundation
import Combine

public typealias Middleware<State, Action, Environment> = (State, Action, Environment) -> AnyPublisher<Action, Never>
