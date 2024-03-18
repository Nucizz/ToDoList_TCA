//
//  SubjectFormReducer.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import Foundation
import ComposableArchitecture

extension SubjectFormReducer {
    
    @ReducerBuilder<State, Action>
    var core: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .view(let action):
                switch action {
                case .onAddSubjectButtonTapped:
                    if state.titleField.isEmpty {
                        state.alertState = .init(title: {
                            .init("Fill the form!")
                        }, actions: {
                            ButtonState(action: .send(.dismiss)) {
                                .init("Okay")
                            }
                        }, message: {
                            .init("Please state the subject name.")
                        })
                        return .none
                    }
                    return .send(.internal(.handleAddSubject))
                }
            case .internal(let action):
                switch action {
                case .handleAddSubject:
                    var newSubject = Subject(
                        title: state.titleField
                    )
                    
                    if !state.sourceUrlField.isEmpty {
                        if !state.sourceUrlField.hasPrefix("http") {
                            state.sourceUrlField = "http://\(state.sourceUrlField)"
                        }
                        newSubject.sourceUrl = state.sourceUrlField
                    }
                    
                    if !state.noteField.isEmpty {
                        newSubject.note = state.noteField
                    }
                    
                    return .send(.external(.onSubjectAdded(newSubject)))
                }
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
