//
//  The_Composable_ArchitectureApp.swift
//  The Composable Architecture
//
//  Created by Irvina Kočan on 28. 7. 2024..
//

import SwiftUI
import ComposableArchitecture

@main
struct The_Composable_ArchitectureApp: App {
    
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            CounterView(store: The_Composable_ArchitectureApp.store)
        }
    }
}
