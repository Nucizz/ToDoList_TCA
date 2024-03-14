//
//  DestinationFormStore.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 06-03-2024.
//

import Foundation
import ComposableArchitecture
import CoreLocation

struct DestinationFormReducer: ReducerProtocol {
    
    struct State: Equatable {
        @BindingState var destinationNameField: String = ""
        @BindingState var searchField: String = ""
        @BindingState var searchResult: [Destination] = []
        @BindingState var addressField: String = ""
        
        
        @BindingState var longitude: Double? = nil
        @BindingState var latitude: Double? = nil
        @BindingState var isMarked: Bool = false
        
        @PresentationState var alertState: AlertState<Action.AlertAction>?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case view(ViewAction)
        case `internal`(InternalAction)
        case external(ExternalAction)
        
        case alertAction(PresentationAction<AlertAction>)
        
        enum ViewAction {
            case onFindAddressComponentCalled
            case onAddressRowTapped(Destination)
            case onAddDestinationButtonTapped
        }
        
        enum InternalAction {
            case initLocation
            case handleAddDestination
            case handleAddressList([Destination])
        }
        
        enum ExternalAction {
            case onDestinationAdded(Destination)
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
