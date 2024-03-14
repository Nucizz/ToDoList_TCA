//
//  SubjectFormStore.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import Foundation
import ComposableArchitecture

struct SubjectFormReducer: ReducerProtocol {
    
    struct State: Equatable {
        @BindingState var titleField: String = ""
        @BindingState var sourceUrlField: String = ""
        @BindingState var noteField: String = ""
        
        @PresentationState var alertState: AlertState<Action.AlertAction>?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case view(ViewAction)
        case `internal`(InternalAction)
        case external(ExternalAction)
        case alertAction(PresentationAction<AlertAction>)
        
        enum ViewAction {
            case onAddSubjectButtonTapped
        }
        
        enum InternalAction {
            case handleAddSubject
        }
        
        enum ExternalAction {
            case onSubjectAdded(Subject)
        }
        
        enum AlertAction {
            case dismiss
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        core
    }
    
}
