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
    @Dependency(\.locationRepository) var locationRepository
    
    struct State: Equatable {
        @BindingState var destinationNameField: String = ""
        @BindingState var searchField: String = ""
        @BindingState var searchResult: [Destination] = []
        @BindingState var addressField: String = ""
        
        var longitude: Double? = nil
        var latitude: Double? = nil
        var isMarked: Bool = false
        
        @PresentationState var alertState: AlertState<Action.AlertAction>?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case view(ViewAction)
        case `internal`(InternalAction)
        case external(ExternalAction)
        
        case alertAction(PresentationAction<AlertAction>)
        
        enum ViewAction: Equatable {
            case onFindAddressComponentCalled
            case onAddressRowTapped(Destination)
            case onAddDestinationButtonTapped
        }
        
        enum InternalAction: Equatable {
            case handleAddDestination
            case handleAddressList([Destination])
        }
        
        enum ExternalAction: Equatable {
            case onDestinationAdded(Destination)
        }
        
        enum AlertAction: Equatable {
            case dismiss
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        core
    }
    
}
