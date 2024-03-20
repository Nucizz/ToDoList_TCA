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
                    do {
                        try toDoRepository.updateToDo(state.toDo)
                        state.toDo.isFinished.toggle()
                        return .send(.external(.onToDoIsFinishedToggled(state.toDo)))
                    } catch {
                        state.alertState = .init(title: {
                            .init("Failed to finish todo!")
                        }, actions: {
                            ButtonState(action: .send(.dismiss)) {
                                .init("Okay")
                            }
                        }, message: {
                            .init(error.localizedDescription)
                        })
                        return .none
                    }
                case .onDeleteButtonTapped:
                    do {
                        try toDoRepository.deleteToDo(state.toDo.id)
                        return .send(.external(.onToDoDeleted(state.toDo)))
                    } catch {
                        state.alertState = .init(title: {
                            .init("Failed to delete todo!")
                        }, actions: {
                            ButtonState(action: .send(.dismiss)) {
                                .init("Okay")
                            }
                        }, message: {
                            .init(error.localizedDescription)
                        })
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
                        if let shoppingToDo = state.toDo.getValue() as? ShoppingToDo {
                            state.shoppingToDoDetailState = .init(toDo: shoppingToDo)
                        }
                        return .none
                    case .traveling:
                        if let travelingToDo = state.toDo.getValue() as? TravelingToDo {
                            state.travellingToDoDetailState = .init(toDo: travelingToDo)
                        }
                        return .none
                    case .learning:
                        if let learningToDo = state.toDo.getValue() as? LearningToDo {
                            state.learningToDoDetailState = .init(toDo: learningToDo)
                        }
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
            case .alertAction(let action):
                switch action {
                case .dismiss:
                    state.alertState = nil
                    return .none
                case .presented:
                    return .none
                }
            }
        }
    }
    
}
