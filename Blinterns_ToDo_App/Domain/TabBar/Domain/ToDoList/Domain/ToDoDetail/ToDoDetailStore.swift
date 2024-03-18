//
//  ToDoStore.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 04-03-2024.
//

import Foundation
import ComposableArchitecture

struct ToDoDetailReducer: ReducerProtocol {
    @Dependency(\.toDoRepository) var toDoRepository
    
    struct State: Equatable {
        @BindingState var toDo: AnyToDoModel
        
        @PresentationState var toDoFormState: ToDoFormReducer.State?
        @PresentationState var alertState: AlertState<Action.AlertAction>?
        
        @BindingState var shoppingToDoDetailState: ShoppingToDoDetailReducer.State? = nil
        @BindingState var travellingToDoDetailState: TravelingToDoDetailReducer.State? = nil
        @BindingState var learningToDoDetailState: LearningToDoDetailReducer.State? = nil
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case view(ViewAction)
        case `internal`(InternalAction)
        case external(ExternalAction)
        
        case toDoFormAction(PresentationAction<ToDoFormReducer.Action>)
        case shoppingToDoDetailAction(ShoppingToDoDetailReducer.Action)
        case travelingToDoDetailAction(TravelingToDoDetailReducer.Action)
        case learningToDoDetailAction(LearningToDoDetailReducer.Action)
        
        case alertAction(PresentationAction<AlertAction>)
        
        enum ViewAction: Equatable {
            case onFinishButtonToggled
            case onDeleteButtonTapped
            case onEditButtonTapped
        }
        
        enum InternalAction: Equatable {
            case handleToDoTypeDetail
        }
        
        enum ExternalAction: Equatable {
            case onToDoDeleted(AnyToDoModel)
            case onToDoIsFinishedToggled(AnyToDoModel)
            case onToDoUpdated(AnyToDoModel)
        }
        
        enum AlertAction: Equatable {
            case dismiss
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
            .self.ifLet(\.$toDoFormState, action: /Action.toDoFormAction) {
                ToDoFormReducer()
            }
        core
    }
    
}
