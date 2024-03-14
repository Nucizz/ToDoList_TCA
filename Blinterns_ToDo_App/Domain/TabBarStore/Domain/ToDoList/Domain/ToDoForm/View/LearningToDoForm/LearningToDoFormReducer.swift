//
//  LearningToDoFormState.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import Foundation
import ComposableArchitecture

extension LearningToDoFormReducer {
    
    @ReducerBuilder<State, Action>
    var core: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .view(let action):
                switch action {
                case .onAddSubjectButtonTapped:
                    state.addSubjectState = .init()
                    return .none
                case .subjectRowLongPressed(let index):
                    state.alertState = .init(title: {
                        .init("Delete Subject!")
                    }, actions: {
                        ButtonState(action: .send(.dismiss)) {
                            .init("Cancel")
                        }
                        ButtonState(action: .send(.onDeleteSubject(index))) {
                            .init("Delete")
                        }
                    }, message: {
                        .init("Are you sure you want to delete this subject?")
                    })
                    return .none
                }
            case .addSubjectAction(let action):
                switch action {
                case .dismiss:
                    state.addSubjectState = nil
                    return .none
                case .presented(let action):
                    switch action {
                    case .external(let action):
                        switch action {
                        case .onSubjectAdded(let newSubject):
                            state.subjectList.append(newSubject)
                            return .send(.addSubjectAction(.dismiss))
                        }
                    default:
                        return .none
                    }
                }
            case .alertAction(let action):
                switch action {
                case .dismiss:
                    state.alertState = nil
                    return .none
                case .presented(let action):
                    switch action {
                    case .onDeleteSubject(let index):
                        state.subjectList.remove(at: index)
                        return .send(.alertAction(.dismiss))
                    default:
                        return .none
                    }
                }
            }
        }
    }
    
}
