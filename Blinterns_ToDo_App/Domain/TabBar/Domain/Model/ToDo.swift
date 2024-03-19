//
//  ToDo.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import Foundation
import SwiftUI

protocol ToDoProtocol {
    var id: UUID { set get }
    var title: String { set get }
    var description: String? { set get }
    var category: ToDoCategory { set get }
    var deadlineTime: Date? { set get }
    var isFinished: Bool { set get }
    func isEqualTo(_ other: ToDoProtocol) -> Bool
}

extension ToDoProtocol where Self: Equatable {
    func isEqualTo(_ other: ToDoProtocol) -> Bool {
        return (other as? Self) == self
    }
}

struct AnyToDoModel: Equatable, Identifiable, Hashable {
    
    static func == (lhs: AnyToDoModel, rhs: AnyToDoModel) -> Bool {
        lhs.value.isEqualTo(rhs.value)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(value.title)
        if let deadlineTime = value.deadlineTime {
            hasher.combine(deadlineTime)
        }
        hasher.combine(value.isFinished)
    }
    
    func getValue() -> ToDoProtocol { //MARK: As Function to state difference between attributes and type
        return value
    }
    
    init(value: ToDoProtocol) { //MARK: For preview data mock
        self.value = value
    }
    
    private var value: ToDoProtocol
    
    var id: UUID {
        get { value.id }
    }
    
    var title: String {
        get { value.title }
        set { value.title = newValue }
    }
    
    var category: ToDoCategory {
        get { value.category }
        set { value.category = newValue }
    }
    
    var description: String? {
        get { value.description }
        set { value.description = newValue }
    }
    
    var deadlineTime: Date? {
        get { value.deadlineTime }
        set { value.deadlineTime = newValue }
    }
    
    var isFinished: Bool {
        get { value.isFinished }
        set { value.isFinished = newValue }
    }
}

enum ToDoCategory: String, CaseIterable, Codable {
    case all = "All"
    case general = "General"
    case shopping = "Shopping"
    case traveling = "Traveling"
    case learning = "Learning"
}

extension ToDoCategory {
    var color: Color {
        switch self {
        case .shopping:
            return Color.orange
        case .traveling:
            return Color.purple
        case .learning:
            return Color.green
        default:
            return Color.accentColor
        }
    }
}
