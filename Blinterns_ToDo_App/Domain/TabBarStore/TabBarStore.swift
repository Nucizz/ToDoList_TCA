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
    }
    
    enum Tab {
        case dashboard
        case toDoList
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case setSelectedTab(Tab)
        case initializeChildState
        case fetchToDo
        case fetchUsername
        case fetchWeather
        case fetchWeatherResponse(TaskResult<WeatherResponse>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        core
    }
    
}
