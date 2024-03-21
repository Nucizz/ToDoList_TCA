//
//  Weather.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 08-03-2024.
//

import Foundation

struct WeatherResponse: Decodable, Equatable {
    
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let name: String
    
    struct Weather: Decodable, Equatable {
        let main: String
        let description: String
    }
    
    struct Main: Decodable, Equatable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case humidity
        }
    }
    
    init(weather: [Weather], main: Main, visibility: Int, name: String) {
        self.weather = weather
        self.main = main
        self.visibility = visibility
        self.name = name
    }
}
