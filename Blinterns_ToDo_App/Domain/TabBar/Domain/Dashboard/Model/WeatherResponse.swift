//
//  Weather.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 08-03-2024.
//

import Foundation

struct WeatherResponse: Codable, Equatable {
    
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let name: String
    
    struct Weather: Codable, Equatable {
        let main: String
        let description: String
    }
    
    struct Main: Codable, Equatable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let humidity: Int
    }
    
    enum CodingKeys: String, CodingKey {
        case weather, main, visibility, name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.weather = try container.decode([Weather].self, forKey: .weather)
        self.main = try container.decode(Main.self, forKey: .main)
        self.visibility = try container.decode(Int.self, forKey: .visibility)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    init(weather: [Weather], main: Main, visibility: Int, name: String) {
        self.weather = weather
        self.main = main
        self.visibility = visibility
        self.name = name
    }
}
