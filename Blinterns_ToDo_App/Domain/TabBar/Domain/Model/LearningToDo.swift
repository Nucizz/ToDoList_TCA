//
//  LearningToDo.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import Foundation

struct LearningToDo: Equatable, Hashable, Codable, ToDoProtocol {
    var id: UUID
    var title: String
    var category: ToDoCategory = .learning
    var description: String?
    var deadlineTime: Date?
    var isFinished: Bool
    
    var subjectList: [Subject]?
}

struct Subject: Equatable, Hashable, Codable {
    var title: String
    var sourceUrl: String?
    var note: String?
}
