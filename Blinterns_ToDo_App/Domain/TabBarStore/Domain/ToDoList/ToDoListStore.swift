//
//  ToDoStore.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import Foundation
import ComposableArchitecture

struct ToDoListReducer: ReducerProtocol {
    
    struct State: Equatable {
        @BindingState var filterValue: ToDoCategory = .all
        var finishedToDoIdList: [ToDoCategory : [UUID]] = [
            .all: [UUID](),
            .general: [UUID](),
            .shopping: [UUID](),
            .traveling: [UUID](),
            .learning: [UUID]()
        ]
        var toDoList: [ToDoCategory : IdentifiedArrayOf<AnyToDoModel>] = [
                .all: IdentifiedArrayOf<AnyToDoModel>(),
                .general: IdentifiedArrayOf<AnyToDoModel>(),
                .shopping: IdentifiedArrayOf<AnyToDoModel>(),
                .traveling: IdentifiedArrayOf<AnyToDoModel>(),
                .learning: IdentifiedArrayOf<AnyToDoModel>()
            ]
        
        @PresentationState var toDoFormState: ToDoFormReducer.State?
        @PresentationState var toDoDetailState: ToDoDetailReducer.State?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case view(ViewAction)
        case `internal`(InternalAction)
        
        case toDoFormAction(PresentationAction<ToDoFormReducer.Action>)
        case toDoDetailAction(PresentationAction<ToDoDetailReducer.Action>)
        
        enum ViewAction {
            case setCategoryFilter
            case onAddButtonTapped
            case onDeleteButtonTapped
            case onFinishCheckboxToggled(AnyToDoModel)
            case onRowViewBodyTapped(AnyToDoModel)
        }
        
        enum InternalAction {
            case handleFinishedListFilter(AnyToDoModel)
        }
        
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        core
            .self.ifLet(\.$toDoFormState, action: /Action.toDoFormAction) {
                ToDoFormReducer()
            }
            .self.ifLet(\.$toDoDetailState, action: /Action.toDoDetailAction) {
                ToDoDetailReducer()
            }
    }
    
}
