//
//  DashboardReducer.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 08-03-2024.
//

import Foundation
import ComposableArchitecture

extension DashboardReducer {
    
    @ReducerBuilder<State, Action>
    var core: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .view(let action):
                switch action {
                case .onLogoutButtonTapped:
                    userDefaultRepository.deleteAll()
                    exit(0)
                }
            }
        }
    }
    
}
