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
        let toDo: AnyToDoModel? = nil
        var name: String = "User"
        
        var weatherResponse: WeatherResponse? = nil
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case view(ViewAction)
        
        enum ViewAction {
            case onLogoutButtonTapped
        }
    }
        
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        core
    }
    
}
