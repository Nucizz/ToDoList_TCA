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

    func testTabBarChildInitialization() async {
        let username = "Nucized"
        let weatherResponse = WeatherResponse (
            weather: [
                WeatherResponse.Weather(main: "Clear", description: "Clear sky"),
            ],
            main: WeatherResponse.Main(
                temp: 25.0, feels_like: 26.0, temp_min: 24.0, temp_max: 26.0, humidity: 70
            ),
            visibility: 10000,
            name: "New York"
        )
        
        let store = TestStore(
          initialState: TabBarReducer.State()
        ) {
            TabBarReducer()
        } withDependencies: {
            $0.userDefaultRepository.fetchUsername = { username }
            $0.weatherRepository.fetchWeather = { _,_ in weatherResponse }
        }
        
        await store.send(.initializeChildState)
        
        await store.receive(.fetchUsername) {
            $0.dashboardState.name = username
        }
        
        await store.receive(.fetchWeather)
        
        await store.receive(.fetchToDo)
        
        await store.receive(.fetchWeatherResponse(.success(weatherResponse))) {
            $0.dashboardState.weatherResponse = weatherResponse
        }
        
    }

}
