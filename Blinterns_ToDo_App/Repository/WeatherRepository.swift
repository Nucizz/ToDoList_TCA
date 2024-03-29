//
//  WeatherRepository.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 08-03-2024.
//

import Dependencies
import Foundation
import ComposableArchitecture

struct WeatherRepository {
    var fetchWeather: @Sendable (Double, Double) async throws -> WeatherResponse
}

extension WeatherRepository: DependencyKey {
    static var liveValue: WeatherRepository {
        return Self(
            fetchWeather: { longitude, latitude in
                let API = APILink()
                guard let url = URL(string: "\(API.openWeatherUrl)?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(API.openWeatherKey)") else {
                    throw CsError.URLError.invalidURLError
                }
                
                let (data, _) = try await URLSession.shared.data(from: url)
                let weatherData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                
                return weatherData
            }
        )
    }
}

extension DependencyValues {
    var weatherRepository: WeatherRepository {
        get { self[WeatherRepository.self] }
        set { self[WeatherRepository.self] = newValue }
    }
}
