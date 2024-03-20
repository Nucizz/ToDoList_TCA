//
//  TabBarReducer.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import Foundation
import ComposableArchitecture

extension TabBarReducer {
    
    @ReducerBuilder<State, Action>
    var core: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .view(let action):
                switch action {
                case .setSelectedTab(let tab):
                    state.selectedTab = tab
                    return .none
                }
            case .internal(let action):
                switch action {
                case .initializeChildState:
                    return .run { send in
                        await send(.internal(.fetchUsername))
                        await send(.internal(.fetchWeather))
                        await send(.internal(.fetchToDo))
                    }
                case .fetchToDo:
                    do {
                        let response = try toDoRepository.fetchToDo()
                        for toDo in response {
                            state.toDoListState.toDoList[toDo.category]?.append(toDo)
                            state.toDoListState.toDoList[.all]?.append(toDo)
                            if toDo.isFinished {
                                state.toDoListState.finishedToDoIdList[toDo.category]?.append(toDo.id)
                                state.toDoListState.finishedToDoIdList[.all]?.append(toDo.id)
                            }
                        }
                    } catch {
                        state.alertState = .init(title: {
                            .init("Something went wrong!")
                        }, actions: {
                            ButtonState(action: .send(.retry)) {
                                .init("Retry")
                            }
                        }, message: {
                            .init(error.localizedDescription)
                        })
                    }
                    return .none
                case .fetchUsername:
                    state.dashboardState.name = userDefaultRepository.fetchUsername()
                    return .none
                case .fetchWeather:
                    let locationHelper = UserLocationHelper()
                    if let coordinates = locationHelper.getCoordinates() {
                        locationHelper.onCoordinatesReturned()
                        return .run { send in
                            await send(.internal(.fetchWeatherResponse(
                                TaskResult { try await weatherRepository.fetchWeather(
                                    coordinates.longitude,
                                    coordinates.latitude
                                )}
                            )))
                        }
                    }
                    return .none
                case .fetchWeatherResponse(.success(let weatherResponse)):
                    state.dashboardState.weatherResponse = weatherResponse
                    return .none
                case .fetchWeatherResponse(.failure(let message)):
                    state.alertState = .init(title: {
                        .init("Something went wrong!")
                    }, actions: {
                        ButtonState(action: .send(.dismiss)) {
                            .init("Okay")
                        }
                    }, message: {
                        .init(message.localizedDescription)
                    })
                    return .none
                }
            case .alertAction(let action):
                switch action {
                case .dismiss:
                    state.alertState = nil
                    return .none
                case .presented(let action):
                    switch action {
                    case .dismiss:
                        return .send(.alertAction(.dismiss))
                    case .retry:
                        return .run { send in
                            await send(.alertAction(.dismiss))
                            await send(.internal(.fetchToDo))
                        }
                    }
                }
            case .dashboardAction(let action):
                switch action {
                case .external(let action):
                    switch action {
                    case .onLogout:
                        return .send(.external(.onLogout))
                    }
                default:
                    return .none
                }
            case .toDoListAction:
                return .none
            case .external:
                return .none
            }
        }
    }
    
}
