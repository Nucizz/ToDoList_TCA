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
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let humidity: Int
    }
    
    init(weather: [Weather], main: Main, visibility: Int, name: String) {
        self.weather = weather
        self.main = main
        self.visibility = visibility
        self.name = name
    }
}
