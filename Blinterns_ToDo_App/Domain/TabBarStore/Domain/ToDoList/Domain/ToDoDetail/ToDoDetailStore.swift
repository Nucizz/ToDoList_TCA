//
//  ToDoStore.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 04-03-2024.
//

import Foundation
import ComposableArchitecture

struct ToDoDetailReducer: ReducerProtocol {
    
    struct State: Equatable {
        @BindingState var toDo: AnyToDoModel
        
        @PresentationState var toDoFormState: ToDoFormReducer.State?
        @BindingState var shoppingToDoDetailState: ShoppingToDoDetailReducer.State? = nil
        @BindingState var travellingToDoDetailState: TravelingToDoDetailReducer.State? = nil
        @BindingState var learningToDoDetailState: LearningToDoDetailReducer.State? = nil
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case view(ViewAction)
        case `internal`(InternalAction)
        case external(ExternalAction)
        
        case toDoFormAction(PresentationAction<ToDoFormReducer.Action>)
        case shoppingToDoDetailAction(ShoppingToDoDetailReducer.Action)
        case travelingToDoDetailAction(TravelingToDoDetailReducer.Action)
        case learningToDoDetailAction(LearningToDoDetailReducer.Action)
        
        enum ViewAction {
            case onFinishButtonToggled
            case onDeleteButtonTapped
            case onEditButtonTapped
        }
        
        enum InternalAction {
            case handleToDoTypeDetail
        }
        
        enum ExternalAction {
            case onToDoDeleted(AnyToDoModel)
            case onToDoIsFinishedToggled(AnyToDoModel)
            case onToDoUpdated(AnyToDoModel)
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
