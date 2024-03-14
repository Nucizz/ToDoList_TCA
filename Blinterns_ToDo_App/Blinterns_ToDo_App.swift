//
//  Blinterns_ToDo_AppApp.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct Blinterns_ToDo_App: App {
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: RootReducer.State()) {
                RootReducer()
            })
        }
    }
}
