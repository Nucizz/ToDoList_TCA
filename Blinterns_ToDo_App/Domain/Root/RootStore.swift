//
//  RootStore.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import Foundation
import ComposableArchitecture

struct RootReducer: ReducerProtocol {
    @Dependency(\.date) var date
    @Dependency(\.userDefaultRepository) var userDefaultRepository
    
    struct State: Equatable {
        @BindingState var isLoginAlertPresented: Bool = false
        @BindingState var nameField: String = " "
        
        @PresentationState var tabBarState: TabBarReducer.State?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onAppear
        case initTabBarView
        case tabBarAction(PresentationAction<TabBarReducer.Action>)
        case presentLoginAlert
        case onLoginButtonTapped
        case alertInternalBugWorkaround
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        core
            .self.ifLet(\.$tabBarState, action: /Action.tabBarAction) {
                TabBarReducer()
            }
    }
    
}

