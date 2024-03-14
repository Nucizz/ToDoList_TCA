//
//  ToDoReducer.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import Foundation
import ComposableArchitecture

extension ToDoListReducer {
    
    @ReducerBuilder<State, Action>
    var core: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .setCategoryFilter:
                    return .none
                case .onAddButtonTapped:
                    state.toDoFormState = .init()
                    return .none
                case .onDeleteButtonTapped:
                    for id in state.finishedToDoIdList[state.filterValue]! {
                        let response = CoreDataRepository().deleteToDo(id: id)
                        if response.success, let toDo = state.toDoList[.all]!.first(where: { $0.id == id }) {
                            state.toDoList[.all]!.remove(toDo)
                            state.toDoList[toDo.category]!.remove(toDo)
                            state.finishedToDoIdList[.all]!.removeAll(where: { $0 == toDo.id })
                            state.finishedToDoIdList[toDo.category]!.removeAll(where: { $0 == toDo.id })
                        }
                    }
                    return .none
                case .onFinishCheckboxToggled(let toDo):
                    let response = CoreDataRepository().updateToDo(toDo: toDo)
                    if response.success {
                        return .send(.internal(.handleFinishedListFilter(toDo)))
                    } else {
                        return .none
                    }
                case .onRowViewBodyTapped(let toDo):
                    state.toDoDetailState = .init(toDo: toDo)
                    return .none
                }
            case .internal(let action):
                switch action {
                case .handleFinishedListFilter(let toDo):
                    if let allIndex = state.toDoList[.all]!.firstIndex(where: { $0.id == toDo.id }) {
                        
                        state.toDoList[.all]![allIndex] = toDo
                        
                        if let allFinishedIndex = state.finishedToDoIdList[.all]!.firstIndex(where: { $0.self == toDo.id }) {
                            state.finishedToDoIdList[.all]!.remove(at: allFinishedIndex)
                        } else {
                            state.finishedToDoIdList[.all]!.append(toDo.id)
                        }
                        
                        if let targetIndex = state.toDoList[toDo.category]!.firstIndex(where: { $0.id == toDo.id }) {
                            
                            state.toDoList[toDo.category]![targetIndex] = toDo
                            
                            if let targetFinishedIndex = state.finishedToDoIdList[toDo.category]!.firstIndex(where: { $0.self == toDo.id }) {
                                state.finishedToDoIdList[toDo.category]!.remove(at: targetFinishedIndex)
                            } else {
                                state.finishedToDoIdList[toDo.category]!.append(toDo.id)
                            }
                            
                        }
                    }
                    return .none
                }
            case .binding:
                return .none
            case .toDoFormAction(let action):
                switch action {
                case .dismiss:
                    state.toDoFormState = nil
                    return .none
                case .presented(let action):
                    switch action {
                    case .external(let action):
                        switch action {
                        case .onToDoAdded(let newToDo):
                            state.toDoList[newToDo.category]!.append(newToDo)
                            state.toDoList[.all]!.append(newToDo)
                            return .send(.toDoFormAction(.dismiss))
                        default:
                            return .none
                        }
                    default:
                        return .none
                    }
                }
            case .toDoDetailAction(let action):
                switch action {
                case .dismiss:
                    state.toDoDetailState = nil
                    return .none
                case .presented(let action):
                    switch action {
                    case .external(let action):
                        switch action {
                        case .onToDoDeleted(let toDo):
                            state.toDoList[.all]!.remove(toDo)
                            state.toDoList[toDo.category]!.remove(toDo)
                            state.finishedToDoIdList[.all]!.removeAll(where: { $0 == toDo.id })
                            state.finishedToDoIdList[toDo.category]!.removeAll(where: { $0 == toDo.id })
                            return .send(.toDoDetailAction(.dismiss))
                        case .onToDoIsFinishedToggled(let toDo):
                            return .send(.internal(.handleFinishedListFilter(toDo)))
                        case .onToDoUpdated(let toDo):
                            if let targetIndex = state.toDoList[.all]!.firstIndex(where: { $0.id == toDo.id }) {
                                state.toDoList[.all]![targetIndex] = toDo
                                if let targetIndex = state.toDoList[toDo.category]!.firstIndex(where: { $0.id == toDo.id }) {
                                    state.toDoList[toDo.category]![targetIndex] = toDo
                                }
                            }
                            return .none
                        }
                    default:
                        return .none
                    }
                }
            }
        }
    }
}
