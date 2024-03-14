//
//  ToDoDetailReducer.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 04-03-2024.
//

import Foundation
import ComposableArchitecture

extension ToDoDetailReducer {
    
    @ReducerBuilder<State, Action>
    var core: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .view(let action):
                switch action {
                case .onFinishButtonToggled:
                    let response = CoreDataRepository().updateToDo(toDo: state.toDo)
                    if response.success {
                        state.toDo.isFinished.toggle()
                        return .send(.external(.onToDoIsFinishedToggled(state.toDo)))
                    } else {
                        return .none
                    }
                case .onDeleteButtonTapped:
                    let response = CoreDataRepository().deleteToDo(id: state.toDo.id)
                    if response.success {
                        return .send(.external(.onToDoDeleted(state.toDo)))
                    } else {
                        return .none
                    }
                case .onEditButtonTapped:
                    state.toDoFormState = .init(toDo: state.toDo)
                    return .none
                }
            case .external:
                return .none
            case .internal(let action):
                switch action {
                case .handleToDoTypeDetail:
                    switch state.toDo.category {
                    case .shopping:
                        state.shoppingToDoDetailState = .init(toDo: state.toDo.getValue() as! ShoppingToDo)
                        return .none
                    case .traveling:
                        state.travellingToDoDetailState = .init(toDo: state.toDo.getValue() as! TravelingToDo)
                        return .none
                    case .learning:
                        state.learningToDoDetailState = .init(toDo: state.toDo.getValue() as! LearningToDo)
                        return .none
                    default:
                        return .none
                    }
                }
            case .toDoFormAction(let action):
                switch action {
                case .dismiss:
                    return .none
                case .presented(let action):
                    switch action {
                    case .external(let action):
                        switch action {
                        case .onToDoEdited(let toDo):
                            state.toDo = toDo
                            state.toDoFormState = nil
                            return .send(.external(.onToDoUpdated(toDo)))
                        default:
                            return .none
                        }
                    default:
                        return .none
                    }
                }
            case .shoppingToDoDetailAction:
                return .none
            case .learningToDoDetailAction:
                return .none
            case .travelingToDoDetailAction:
                return .none
            }
        }
    }
    
}
