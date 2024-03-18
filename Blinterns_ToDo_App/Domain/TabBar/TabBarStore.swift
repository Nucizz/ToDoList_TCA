//
//  ToDoStore.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import Foundation
import ComposableArchitecture

struct TabBarReducer: ReducerProtocol {
    @Dependency(\.toDoRepository) var toDoRepository
    @Dependency(\.userDefaultRepository) var userDefaultRepository
    @Dependency(\.weatherRepository) var weatherRepository
    
    struct State: Equatable {
        @BindingState var selectedTab = Tab.dashboard
        var dashboardState = DashboardReducer.State()
        var toDoListState = ToDoListReducer.State()
        
        @PresentationState var alertState: AlertState<Action.AlertAction>?
    }
    
    enum Tab {
        case dashboard
        case toDoList
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case view(ViewAction)
        case `internal`(InternalAction)
        case external(ExternalAction)
        case dashboardAction(DashboardReducer.Action)
        case toDoListAction(ToDoListReducer.Action)
        
        case alertAction(PresentationAction<AlertAction>)
        
        enum ViewAction: Equatable {
            case setSelectedTab(Tab)
        }
        
        enum AlertAction: Equatable {
            case dismiss
            case retry
        }
        
        enum InternalAction: Equatable {
            case initializeChildState
            case fetchToDo
            case fetchUsername
            case fetchWeather
            case fetchWeatherResponse(TaskResult<WeatherResponse>)
        }
        
        enum ExternalAction: Equatable {
            case onLogout
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        core
        
        Scope(state: \.dashboardState, action: /Action.dashboardAction) {
          DashboardReducer()
        }
        
        Scope(state: \.toDoListState, action: /Action.toDoListAction) {
          ToDoListReducer()
        }
    }
    
}
