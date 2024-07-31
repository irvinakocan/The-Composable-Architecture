//
//  CounterFeature.swift
//  The Composable Architecture
//
//  Created by Irvina Kočan on 28. 7. 2024..
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct CounterFeature {
    @ObservableState
    struct State {
        var count = 0
        var fact: String?
        var isLoading = false
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case factButtonTapped
        case factAction(fact: String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                return .run { [count = state.count] send in
                    guard let url = URL(string: "http://numbersapi.com/\(count)") else {
                        return
                    }
                    
                    let (data, _) = try await URLSession.shared.data(from: url)
                    guard let fact = String(data: data, encoding: .utf8) else {
                        return
                    }
                    
                    // it's not possible to mutate the state.fact in the effect after fetching the data from the network
                    // sendable closures cannot capture inout state
                    // in order to feed the information from the effect back into the reducer we need to introduce another action - factAction
                    
                    await send(.factAction(fact: fact))
                }
            case .factAction(let fact):
                state.fact = fact
                state.isLoading = false 
                return .none
            }
        }
    }
}
