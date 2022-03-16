//
//  File.swift
//  
//
//  Created by Wei Lu on 22/09/2021.
//

import Foundation

public typealias Reducer<State, Action> = (State, Action) -> State
