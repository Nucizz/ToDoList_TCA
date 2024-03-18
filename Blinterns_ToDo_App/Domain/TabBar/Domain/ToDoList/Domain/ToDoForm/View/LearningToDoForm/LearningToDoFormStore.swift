//
//  LearningToDoFormAction.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import Foundation
import ComposableArchitecture

struct LearningToDoFormReducer: ReducerProtocol {
    
    struct State: Equatable {
        var subjectList: [Subject] = []
        
        @PresentationState var addSubjectState: SubjectFormReducer.State?
        @PresentationState var alertState: AlertState<Action.AlertAction>?
        
        init(toDo: LearningToDo? = nil) {
            if let toDoAttribute = toDo {
                self.subjectList = toDoAttribute.subjectList ?? []
            } else {
                self.subjectList = []
            }
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case view(ViewAction)
        
        case addSubjectAction(PresentationAction<SubjectFormReducer.Action>)
        case alertAction(PresentationAction<AlertAction>)
        
        enum ViewAction: Equatable {
            case onAddSubjectButtonTapped
            case subjectRowLongPressed(Int)
        }
        
        enum AlertAction: Equatable {
            case dismiss
            case onDeleteSubject(Int)
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        core
            .self.ifLet(\.$addSubjectState, action: /Action.addSubjectAction) {
                SubjectFormReducer()
            }
    }
    
}
