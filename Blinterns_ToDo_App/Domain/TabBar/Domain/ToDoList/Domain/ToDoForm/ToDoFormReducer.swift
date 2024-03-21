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
                    state.shoppingToDoFormState = nil
                    state.travelingToDoFormState = nil
                    state.learningToDoFormState = nil
                    return self.handleCategoryInitiation(state: &state)
                
                case .onAddOrEditButtonTapped:
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
                    let id = state.editedToDoChildValue?.id ?? uuidRepository.callAsFunction()
                    let isFinished = state.editedToDoChildValue?.isFinished ?? false
                    
                    switch state.categoryValueField {
                    case .general:
                        let newGeneralToDo = AnyToDoModel(
                            value: GeneralTodo(
                                id: id,
                                title: state.titleField,
                                description: descriptionText,
                                deadlineTime: deadlineTime,
                                isFinished: isFinished
                            )
                        )
                        return .send(.internal(.handleAddOrEdit(newGeneralToDo)))
                    
                    case .shopping:
                        guard let shoppingForm = state.shoppingToDoFormState else {
                            return self.handleCategoryInitiation(state: &state)
                        }
                        
                        if shoppingForm.budgetField.isEmpty {
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
                        } else if !NSPredicate(format: "SELF MATCHES %@", RegularExpression.decimal).evaluate(with: state.shoppingToDoFormState?.budgetField) {
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
                                id: id,
                                title: state.titleField,
                                description: descriptionText,
                                deadlineTime: deadlineTime,
                                isFinished: isFinished,
                                budget: Double(shoppingForm.budgetField) ?? 0.0,
                                productList: shoppingForm.productList.isEmpty ? nil : shoppingForm.productList
                            )
                        )
                        return .send(.internal(.handleAddOrEdit(newShoppingToDo)))
                    
                    case .traveling:
                        guard let travelingForm = state.travelingToDoFormState else {
                            return self.handleCategoryInitiation(state: &state)
                        }
                        
                        if travelingForm.budgetField.isEmpty {
                            state.alertState = .init(title: {
                                .init("Fill the form!")
                            }, actions: {
                                ButtonState(action: .send(.dismiss)) {
                                    .init("Okay")
                                }
                            }, message: {
                                .init("Please state the traveling budget.")
                            })
                            return .none
                        } else if !NSPredicate(format: "SELF MATCHES %@", RegularExpression.decimal).evaluate(with: state.travelingToDoFormState!.budgetField) {
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
                                id: id,
                                title: state.titleField,
                                description: descriptionText,
                                deadlineTime: deadlineTime,
                                isFinished: isFinished,
                                budget: Double(travelingForm.budgetField) ?? 0.0,
                                destinationList: travelingForm.destinationList.isEmpty ? nil :
                                    travelingForm.destinationList
                            )
                        )
                        return .send(.internal(.handleAddOrEdit(newTravelingToDo)))
                    
                    case .learning:     
                        guard let learningForm = state.learningToDoFormState else {
                            
                            return self.handleCategoryInitiation(state: &state)
                        }
                        
                        let newLearningToDo = AnyToDoModel(
                            value: LearningToDo(
                                id: id,
                                title: state.titleField,
                                description: descriptionText,
                                deadlineTime: deadlineTime,
                                isFinished: isFinished,
                                subjectList: learningForm.subjectList.isEmpty ? nil : learningForm.subjectList
                            )
                        )
                        return .send(.internal(.handleAddOrEdit(newLearningToDo)))
                    default:
                        return .none
                    }
                }
            
            case .internal(let action):
                switch action {
                case .handleAddOrEdit(let toDo):
                    if state.isEditing {
                        do {
                            try toDoRepository.updateToDo(toDo)
                            return .send(.external(.onToDoEdited(toDo)))
                        } catch {
                            state.alertState = .init(title: {
                                .init("Something Went Wrong")
                            }, actions: {
                                ButtonState(action: .send(.dismiss)) {
                                    .init("Okay")
                                }
                            }, message: {
                                .init(error.localizedDescription)
                            })
                            return .none
                        }
                    } else {
                        do {
                            try toDoRepository.createToDo(toDo)
                            return .send(.external(.onToDoAdded(toDo)))
                        } catch {
                            state.alertState = .init(title: {
                                .init("Something Went Wrong")
                            }, actions: {
                                ButtonState(action: .send(.dismiss)) {
                                    .init("Okay")
                                }
                            }, message: {
                                .init(error.localizedDescription)
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
    
    func handleCategoryInitiation(state: inout State) -> EffectTask<Action> {
        if state.isEditing {
            switch state.categoryValueField {
            case .shopping:
                state.shoppingToDoFormState = .init(toDo: state.editedToDoChildValue?.getValue() as? ShoppingToDo)
                return .none
            case .traveling:
                state.travelingToDoFormState = .init(toDo: state.editedToDoChildValue?.getValue() as? TravelingToDo)
                return .none
            case .learning:
                state.learningToDoFormState = .init(toDo: state.editedToDoChildValue?.getValue() as? LearningToDo)
                return .none
            default:
                return .none
            }
        } else {
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
        }
    }
    
}
