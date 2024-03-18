//
//  GeneralToDo.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import Foundation

struct GeneralTodo: Equatable, Hashable, Codable, ToDoProtocol {
    var id: UUID
    var title: String
    var category: ToDoCategory = .general
    var description: String?
    var deadlineTime: Date?
    var isFinished: Bool
}
