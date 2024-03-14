//
//  AddToDoReducer.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import Foundation
import ComposableArchitecture

extension ToDoFormReducer {
    
    @ReducerBuilder<State, Action>
    var core: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .view(let action):
                switch action {
                case .onCategoryFieldSelected:
                    switch state.categoryValueField {
                    case .shopping:
                        state.shoppingToDoFormState = .init()
                        return .none
                    case .traveling:
                        state.travelingToDoFormState = .init()
                        return .none
                    case .learning:
                        state.learningToDoFormState = .init()
                        return .none
                    default:
                        return .none
                    }
                case .onAddButtonTapped:
                    if state.titleField.isEmpty {
                        state.alertState = .init(title: {
                            .init("Fill the form!")
                        }, actions: {
                            ButtonState(action: .send(.dismiss)) {
                                .init("Okay")
                            }
                        }, message: {
                            .init("Please state the to-do title.")
                        })
                        return .none
                    }
                    
                    let descriptionText = state.descriptionField.isEmpty ? nil : state.descriptionField
                    let deadlineTime = state.isDeadlineTimeActive ? state.deadlineTimeField : nil
                    let id = state.editedToDoChildValue != nil ? state.editedToDoChildValue?.id : nil
                    
                    switch state.categoryValueField {
                    case .general:
                        let newGeneralToDo = AnyToDoModel(
                            value: GeneralTodo(
                                id: id ?? UUID(), title: state.titleField, description: descriptionText,
                                deadlineTime: deadlineTime, isFinished: false
                            )
                        )
                        return .send(.internal(.handleAddOrEdit(newGeneralToDo)))
                    case .shopping:
                        if state.shoppingToDoFormState.budgetField.isEmpty {
                            state.alertState = .init(title: {
                                .init("Fill the form!")
                            }, actions: {
                                ButtonState(action: .send(.dismiss)) {
                                    .init("Okay")
                                }
                            }, message: {
                                .init("Please state the shopping budget.")
                            })
                            return .none
                        } else if !NSPredicate(format: "SELF MATCHES %@", RegularExpression.decimal).evaluate(with: state.shoppingToDoFormState.budgetField) {
                            state.alertState = .init(title: {
                                .init("Invalid form statement!")
                            }, actions: {
                                ButtonState(action: .send(.dismiss)) {
                                    .init("Okay")
                                }
                            }, message: {
                                .init("Budget can only be decimal.")
                            })
                            return .none
                        }
                        
                        let newShoppingToDo = AnyToDoModel(
                            value: ShoppingToDo(
                                id: id ?? UUID(), title: state.titleField, description: descriptionText,
                                deadlineTime: deadlineTime, isFinished: false,
                                budget: Double(state.shoppingToDoFormState.budgetField)!,
                                productList: state.shoppingToDoFormState.productList
                            )
                        )
                        return .send(.internal(.handleAddOrEdit(newShoppingToDo)))
                    case .traveling:
                        if state.travelingToDoFormState.budgetField.isEmpty {
                            state.alertState = .init(title: {
                                .init("Fill the form!")
                            }, actions: {
                                ButtonState(action: .send(.dismiss)) {
                                    .init("Okay")
                                }
                            }, message: {
                                .init("Please state the shopping budget.")
                            })
                            return .none
                        } else if !NSPredicate(format: "SELF MATCHES %@", RegularExpression.decimal).evaluate(with: state.travelingToDoFormState.budgetField) {
                            state.alertState = .init(title: {
                                .init("Invalid form statement!")
                            }, actions: {
                                ButtonState(action: .send(.dismiss)) {
                                    .init("Okay")
                                }
                            }, message: {
                                .init("Budget can only be decimal.")
                            })
                            return .none
                        }
                        
                        let newTravelingToDo = AnyToDoModel(
                            value: TravelingToDo(
                                id: id ?? UUID(), title: state.titleField, description: descriptionText,
                                deadlineTime: deadlineTime, isFinished: false,
                                budget: Double(state.travelingToDoFormState.budgetField)!,
                                destinationList: state.travelingToDoFormState.destinationList
                            )
                        )
                        return .send(.internal(.handleAddOrEdit(newTravelingToDo)))
                    case .learning:                        
                        let newLearningToDo = AnyToDoModel(
                            value: LearningToDo(
                                id: id ?? UUID(), title: state.titleField, description: descriptionText,
                                deadlineTime: deadlineTime, isFinished: false,
                                subjectList: state.learningToDoFormState.subjectList
                            )
                        )
                        return .send(.internal(.handleAddOrEdit(newLearningToDo)))
                    default:
                        return .none
                    }
                }
            case .internal(let action):
                switch action {
                case .handleCategoryInitiation:
                    if state.isEditing {
                        switch state.categoryValueField {
                        case .shopping:
                            state.shoppingToDoFormState = .init(toDo: state.editedToDoChildValue!.getValue() as? ShoppingToDo)
                            return .none
                        case .traveling:
                            state.travelingToDoFormState = .init(toDo: state.editedToDoChildValue!.getValue() as? TravelingToDo)
                            return .none
                        case .learning:
                            state.learningToDoFormState = .init(toDo: state.editedToDoChildValue!.getValue() as? LearningToDo)
                            return .none
                        default:
                            return .none
                        }
                    } else {
                        return .none
                    }
                case .handleAddOrEdit(let toDo):
                    if state.isEditing {
                        let response = CoreDataRepository().updateToDo(toDo: toDo)
                        if response.success {
                            return .send(.external(.onToDoEdited(toDo)))
                        } else {
                            state.alertState = .init(title: {
                                .init("Error!")
                            }, actions: {
                                ButtonState(action: .send(.dismiss)) {
                                    .init("Okay")
                                }
                            }, message: {
                                .init(response.message!)
                            })
                            return .none
                        }
                    } else {
                        let response = CoreDataRepository().createToDo(toDo: toDo)
                        if response.success {
                            return .send(.external(.onToDoAdded(toDo)))
                        } else {
                            state.alertState = .init(title: {
                                .init("Error!")
                            }, actions: {
                                ButtonState(action: .send(.dismiss)) {
                                    .init("Okay")
                                }
                            }, message: {
                                .init(response.message!)
                            })
                            return .none
                        }
                    }
                }
            case .shoppingToDoFormAction:
                return .none
            case .travelingToDoFormAction:
                return .none
            case .learningToDoFormAction:
                return .none
            case .external:
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
