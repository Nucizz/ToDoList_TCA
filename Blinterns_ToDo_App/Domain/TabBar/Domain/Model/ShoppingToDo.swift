//
//  ShoppingToDo.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import Foundation

struct ShoppingToDo: Equatable, Hashable, Codable, ToDoProtocol {
    var id: UUID
    var title: String
    var category: ToDoCategory = .shopping
    var description: String?
    var deadlineTime: Date?
    var isFinished: Bool
    
    var budget: Double
    var productList: [Product]?
}

struct Product: Equatable, Hashable, Codable {
    var name: String
    var imagePath: String?
    var storeUrl: String?
}
