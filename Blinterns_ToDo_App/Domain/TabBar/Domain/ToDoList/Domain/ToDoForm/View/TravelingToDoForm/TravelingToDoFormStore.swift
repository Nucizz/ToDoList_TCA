//
//  TravelingToDoStore.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 06-03-2024.
//

import Foundation
import ComposableArchitecture

struct TravelingToDoFormReducer: ReducerProtocol {
    
    struct State: Equatable {
        @BindingState var budgetField: String = ""
        
        var destinationList: [Destination] = []
        
        @PresentationState var addDestinationState: DestinationFormReducer.State?
        @PresentationState var alertState: AlertState<Action.AlertAction>?
        
        init(toDo: TravelingToDo? = nil) {
            if let toDoAttribute = toDo {
                self.budgetField = "\(toDoAttribute.budget)"
                self.destinationList = toDoAttribute.destinationList ?? []
            } else {
                self.budgetField = ""
                self.destinationList = []
            }
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case view(ViewAction)
        
        case addDestinationAction(PresentationAction<DestinationFormReducer.Action>)
        case alertAction(PresentationAction<AlertAction>)
        
        enum ViewAction: Equatable {
            case onAddDestinationButtonTapped
            case destinationRowLongPressed(Int)
        }
        
        enum AlertAction: Equatable {
            case dismiss
            case onDeleteDestination(Int)
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        core
            .self.ifLet(\.$addDestinationState, action: /Action.addDestinationAction) {
                DestinationFormReducer()
            }
    }
    
}
