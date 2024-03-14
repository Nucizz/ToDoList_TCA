//
//  AddToDoStore.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import Foundation
import ComposableArchitecture

struct ToDoFormReducer: ReducerProtocol {
    
    struct State: Equatable {
        var isEditing: Bool = false
        var editedToDoChildValue: AnyToDoModel?
        
        @BindingState var categoryValueField: ToDoCategory
        @BindingState var titleField: String
        @BindingState var descriptionField: String
        @BindingState var deadlineTimeField: Date
        @BindingState var isDeadlineTimeActive: Bool
        
        var shoppingToDoFormState: ShoppingToDoFormReducer.State = .init()
        var travelingToDoFormState: TravelingToDoFormReducer.State = .init()
        var learningToDoFormState: LearningToDoFormReducer.State = .init()
        @PresentationState var alertState: AlertState<Action.AlertAction>?
        
        init(toDo: AnyToDoModel? = nil) {
            if let toDoAttribute = toDo {
                self.editedToDoChildValue = toDoAttribute
                self.categoryValueField = toDoAttribute.category
                self.titleField = toDoAttribute.title
                self.descriptionField = toDoAttribute.description ?? ""
                self.deadlineTimeField = toDoAttribute.deadlineTime ?? Date.now
                self.isDeadlineTimeActive = toDoAttribute.deadlineTime == nil ? false : true
                isEditing = true
            } else {
                self.categoryValueField = .general
                self.titleField = ""
                self.descriptionField = ""
                self.deadlineTimeField = Date.now
                self.isDeadlineTimeActive = false
            }
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case view(ViewAction)
        case `internal`(InternalAction)
        case external(ExternalAction)
        
        case shoppingToDoFormAction(ShoppingToDoFormReducer.Action)
        case travelingToDoFormAction(TravelingToDoFormReducer.Action)
        case learningToDoFormAction(LearningToDoFormReducer.Action)
        case alertAction(PresentationAction<AlertAction>)
        
        enum ViewAction {
            case onCategoryFieldSelected
            case onAddButtonTapped
        }
        
        enum InternalAction {
            case handleCategoryInitiation
            case handleAddOrEdit(AnyToDoModel)
        }
        
        enum ExternalAction {
            case onToDoAdded(AnyToDoModel)
            case onToDoEdited(AnyToDoModel)
        }
        
        enum AlertAction {
            case dismiss
        }
        
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Scope(state: \.shoppingToDoFormState, action: /Action.shoppingToDoFormAction) {
          ShoppingToDoFormReducer()
        }
        
        Scope(state: \.travelingToDoFormState, action: /Action.travelingToDoFormAction) {
          TravelingToDoFormReducer()
        }
        
        Scope(state: \.learningToDoFormState, action: /Action.learningToDoFormAction) {
          LearningToDoFormReducer()
        }
        
        core
    }
    
}
