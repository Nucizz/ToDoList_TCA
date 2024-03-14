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
            case .setSelectedTab(let tab):
                state.selectedTab = tab
                return .none
            case .initializeChildState:
                return .run { send in
                    await send(.fetchUsername)
                    await send(.fetchWeather)
                    await send(.fetchToDo)
                }
            case .fetchToDo:
            let response = CoreDataRepository().fetchAllToDo()
                if response.success {
                    if let responseData = response.data as? [AnyToDoModel] {
                        for toDo in responseData {
                            state.toDoListState.toDoList[toDo.category]!.append(toDo)
                            state.toDoListState.toDoList[.all]!.append(toDo)
                            if toDo.isFinished {
                                state.toDoListState.finishedToDoIdList[toDo.category]!.append(toDo.id)
                                state.toDoListState.finishedToDoIdList[.all]!.append(toDo.id)
                            }
                        }
                    }
                }
                return .none
            case .fetchUsername:
                state.dashboardState.name = userDefaultRepository.fetchUsername()
                return .none
            case .fetchWeather:
                if let coordinates = UserLocationHelper().getCoordinates() {
                    return .run { send in
                        await send(.fetchWeatherResponse(
                            TaskResult { try await weatherRepository.fetchWeather(
                                coordinates.longitude,
                                coordinates.latitude
                            )}
                        ))
                    }
                }
                return .none
            case .fetchWeatherResponse(.success(let weatherResponse)):
                state.dashboardState.weatherResponse = weatherResponse
                return .none
            case .fetchWeatherResponse(.failure(let message)):
                print(message)
                return .none
            }
        }
    }
    
}
