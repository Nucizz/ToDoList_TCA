//
//  DashboardStore.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 08-03-2024.
//

import Foundation
import ComposableArchitecture

struct DashboardReducer: ReducerProtocol {    
    @Dependency(\.userDefaultRepository) var userDefaultRepository
    
    struct State: Equatable {
        var name: String = "User"
        
        var weatherResponse: WeatherResponse? = nil
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case view(ViewAction)
        case external(ExternalAction)
        
        enum ViewAction {
            case onLogoutButtonTapped
        }
        
        enum ExternalAction {
            case onLogout
        }
    }
        
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        core
    }
    
}
