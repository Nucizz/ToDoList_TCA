//
//  TravelingToDoFormReducer.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 06-03-2024.
//

import Foundation
import ComposableArchitecture

extension TravelingToDoFormReducer {
    
    @ReducerBuilder<State, Action>
    var core: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            
            case .view(let action):
                switch action {
                case .onAddDestinationButtonTapped:
                    state.addDestinationState = .init()
                    return .none
                
                case .destinationRowLongPressed(let index):
                    state.alertState = .init(title: {
                        .init("Delete destination!")
                    }, actions: {
                        ButtonState(action: .send(.dismiss)) {
                            .init("Cancel")
                        }
                        ButtonState(action: .send(.onDeleteDestination(index))) {
                            .init("Delete")
                        }
                    }, message: {
                        .init("Are you sure you want to delete this destination?")
                    })
                    return .none
                }
            
            case .addDestinationAction(let action):
                switch action {
                case .dismiss:
                    state.addDestinationState = nil
                    return .none
                
                case .presented(let action):
                    switch action {
                    case .external(let action):
                        switch action {
                        case .onDestinationAdded(let newDestination):
                            state.destinationList.append(newDestination)
                            return .send(.addDestinationAction(.dismiss))
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
                    case .onDeleteDestination(let index):
                        state.destinationList.remove(at: index)
                        return .send(.alertAction(.dismiss))
                    
                    default:
                        return .none
                    }
                }
            }
        }
    }
}
