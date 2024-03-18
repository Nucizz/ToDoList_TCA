//
//  TravelingToDo.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import Foundation

struct TravelingToDo: Equatable, Hashable, Codable, ToDoProtocol {
    var id: UUID
    var title: String
    var category: ToDoCategory = .traveling
    var description: String?
    var deadlineTime: Date?
    var isFinished: Bool
    
    var budget: Double
    var destinationList: [Destination]?
}

struct Destination: Equatable, Hashable, Identifiable, Codable {
    var name: String
    var address: String?
    var longitude: Double?
    var latitude: Double?
    
    var id: String {
        "\(name)-\(latitude ?? 0)-\(longitude ?? 0)"
    }
}
