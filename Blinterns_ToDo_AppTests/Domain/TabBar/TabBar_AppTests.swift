//
//  TabBar_AppTests.swift
//  Blinterns_ToDo_AppTests
//
//  Created by Calvin Anacia Suciawan on 13-03-2024.
//

import XCTest
import ComposableArchitecture
@testable import Blinterns_ToDo_App

@MainActor
final class TabBar_AppTests: XCTestCase {
    
    let username = "Nucized"
    let weatherResponse = WeatherResponse (
        weather: [
            WeatherResponse.Weather(main: "Clear", description: "Clear sky"),
        ],
        main: WeatherResponse.Main(
            temp: 25.0, feelsLike: 26.0, tempMin: 24.0, tempMax: 26.0, humidity: 70
        ),
        visibility: 10000,
        name: "New York"
    )
    let toDoList = [
        AnyToDoModel(value: GeneralTodo(id: UUID(), title: "Supanika", deadlineTime: Date.distantFuture, isFinished: false)),
        AnyToDoModel(value: ShoppingToDo(id: UUID(), title: "Belanja di Blibli", deadlineTime: Date.distantPast, isFinished: false, budget: 26500)),
        AnyToDoModel(value: TravelingToDo(id: UUID(), title: "Healing akhir pekan", description: "Biar ga gila masbro", isFinished: true, budget: 150000)),
        AnyToDoModel(value: LearningToDo(id: UUID(), title: "Belajar testing di TCA", isFinished: false))
    ]

}

extension TabBar_AppTests {
    
    func testTabBarChildInitialization() async {
        let store = TestStore(
          initialState: TabBarReducer.State()
        ) {
            TabBarReducer()
        } withDependencies: {
            $0.userDefaultRepository.fetchUsername = { self.username }
            $0.weatherRepository.fetchWeather = { _,_ in self.weatherResponse }
            $0.toDoRepository.fetchToDo = { self.toDoList }
        }
        
        await store.send(.internal(.initializeChildState))

        await store.receive(.internal(.fetchUsername)) {
            $0.dashboardState.name = self.username
        }
        
        await store.receive(.internal(.fetchWeather))
        
        await store.receive(.internal(.fetchToDo)) {
            for toDo in self.toDoList {
                $0.toDoListState.toDoList[toDo.category]?.append(toDo)
                $0.toDoListState.toDoList[.all]?.append(toDo)
                if toDo.isFinished {
                    $0.toDoListState.finishedToDoIdList[toDo.category]?.append(toDo.id)
                    $0.toDoListState.finishedToDoIdList[.all]?.append(toDo.id)
                }
            }
        }
                
        await store.receive(.internal(.fetchWeatherResponse(.success(weatherResponse)))) {
            $0.dashboardState.weatherResponse = self.weatherResponse
        }
    }
    
    func testChangeTab() async {
        let store = TestStore(
          initialState: TabBarReducer.State()
        ) {
            TabBarReducer()
        }
        
        await store.send(.view(.setSelectedTab(.toDoList))) {
            $0.selectedTab = .toDoList
        }
        
        await store.send(.view(.setSelectedTab(.dashboard))) {
            $0.selectedTab = .dashboard
        }
    }
    
    func testFetchWeatherFailure() async {
        let store = TestStore(
          initialState: TabBarReducer.State()
        ) {
            TabBarReducer()
        } withDependencies: {
            $0.weatherRepository.fetchWeather = { _,_ in throw CsError.URLError.invalidURLError }
        }
        
        await store.send(.internal(.fetchWeather))
                
        await store.receive(.internal(.fetchWeatherResponse(.failure(CsError.URLError.invalidURLError)))) {
            $0.alertState = .init(title: {
                .init("Something went wrong!")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Okay")
                }
            }, message: {
                .init(CsError.URLError.invalidURLError.localizedDescription)
            })
        }
        
        await store.send(.alertAction(.dismiss)) {
            $0.alertState = nil
        }
        
    }
    
    func testFetchToDoFailure() async {
        let store = TestStore(
          initialState: TabBarReducer.State()
        ) {
            TabBarReducer()
        } withDependencies: {
            $0.toDoRepository.fetchToDo = { throw CsError.JsonError.conversionFailure }
        }
        
        await store.send(.internal(.fetchToDo)) {
            $0.alertState = .init(title: {
                .init("Something went wrong!")
            }, actions: {
                ButtonState(action: .send(.retry)) {
                    .init("Retry")
                }
            }, message: {
                .init(CsError.JsonError.conversionFailure.localizedDescription)
            })
        }
        
        await store.send(.alertAction(.presented(.retry)))
        
        await store.receive(.alertAction(.dismiss)) {
            $0.alertState = nil
        }
        
        await store.receive(.internal(.fetchToDo))  {
            $0.alertState = .init(title: {
                .init("Something went wrong!")
            }, actions: {
                ButtonState(action: .send(.retry)) {
                    .init("Retry")
                }
            }, message: {
                .init(CsError.JsonError.conversionFailure.localizedDescription)
            })
        }
    }

    
    func testOnLogout() async {
        let store = TestStore(
          initialState: TabBarReducer.State()
        ) {
            TabBarReducer()
        }
        
        await store.send(.dashboardAction(.external(.onLogout)))
        
        await store.receive(.external(.onLogout))
    }
    
}
