//
//  DestinationFormReducer.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 06-03-2024.
//

import Foundation
import ComposableArchitecture

extension DestinationFormReducer {
    
    @ReducerBuilder<State, Action>
    var core: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .view(let action):
                switch action {
                case .onFindAddressComponentCalled:
                    let searchQuery = state.searchField
                    return .run { send in
                        do {
                            let addressList = try await locationRepository.fetchLocation(searchQuery)
                            await send(.internal(.handleAddressList(addressList)))
                        } catch {
                            await send(.internal(.handleAddressList([])))
                        }
                    }
                case .onAddDestinationButtonTapped:
                    if !state.destinationNameField.isEmpty {
                        return .send(.internal(.handleAddDestination))
                    }
                    state.alertState = .init(title: {
                        .init("Fill the form!")
                    }, actions: {
                        ButtonState(action: .send(.dismiss)) {
                            .init("Okay")
                        }
                    }, message: {
                        .init("Please state the destination name.")
                    })
                    return .none
                case .onAddressRowTapped(let address):
                    state.latitude = address.latitude
                    state.longitude = address.longitude
                    state.destinationNameField = address.name
                    state.addressField = address.address ?? ""
                    
                    state.isMarked = true
                    state.searchField = ""
                    state.searchResult.removeAll()
                    return .none
                }
            case .internal(let action):
                switch action {
                case .handleAddDestination:
                    var newDestination = Destination(
                        name: state.destinationNameField,
                        longitude: state.longitude,
                        latitude: state.latitude
                    )
                    
                    if !state.addressField.isEmpty {
                        newDestination.address = state.addressField
                    }
                    
                    return .send(.external(.onDestinationAdded(newDestination)))
                case .handleAddressList(let addressList):
                    state.searchResult = addressList
                    return .none
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
