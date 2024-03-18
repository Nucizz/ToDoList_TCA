//
//  Dashboard_AppTests.swift
//  Blinterns_ToDo_AppTests
//
//  Created by Calvin Anacia Suciawan on 14-03-2024.
//

import XCTest
import ComposableArchitecture
@testable import Blinterns_ToDo_App

@MainActor
final class Dashboard_AppTests: XCTestCase {
    
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
    
}

extension Dashboard_AppTests {
    
    func testInitiation() async {
        let store = TestStore(
          initialState: DashboardReducer.State(
            name: username,
            weatherResponse: weatherResponse
          )
        ) {
            DashboardReducer()
        }
        
        XCTAssertEqual(
            store.state.name,
            username
        )
        
        XCTAssertEqual(
            store.state.weatherResponse,
            weatherResponse
        )
    }
    
    func testLogoutButton() async {
        let store = TestStore(
          initialState: DashboardReducer.State()
        ) {
            DashboardReducer()
        } withDependencies: {
            $0.userDefaultRepository.setUsername(username)
        }
        
        XCTAssertEqual(
            store.dependencies.userDefaultRepository.fetchUsername(),
            username
        )
                
        await store.send(.view(.onLogoutButtonTapped))
        
        XCTAssertEqual(
            store.dependencies.userDefaultRepository.fetchUsername(),
            "User"
        )
        
        await store.receive(.external(.onLogout))
    }

    
}
