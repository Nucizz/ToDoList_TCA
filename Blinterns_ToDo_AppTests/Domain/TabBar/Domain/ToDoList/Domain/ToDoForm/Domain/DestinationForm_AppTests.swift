//
//  DestinationForm_AppTests.swift
//  Blinterns_ToDo_AppTests
//
//  Created by Calvin Anacia Suciawan on 18-03-2024.
//

import XCTest
import ComposableArchitecture
@testable import Blinterns_ToDo_App

@MainActor
final class DestinationForm_AppTests: XCTestCase {

    let mockDestination = Destination(name: "Blibli.com Head Office", address: "Sarana Jaya, Jakarat Pusat, Indonesia")
    
    let mockDestinationWCords = Destination(name: "Blibli.com Head Office", address: "Sarana Jaya, Jakarat Pusat, Indonesia", longitude: -6.2019433, latitude: 106.7809316)
    
    let addressList = [
        Destination(name: "Blibli.com Head Office", address: "Sarana Jaya, Jakarat Pusat, Indonesia", longitude: -6.2019433, latitude: 106.7809316)
    ]
}

extension DestinationForm_AppTests {
    
    func testSearchAddressSuccess() async {
        let store = TestStore(initialState: DestinationFormReducer.State()) {
            DestinationFormReducer()
        } withDependencies: {
            $0.locationRepository.fetchLocation = { _ in self.addressList }
        }
        
        await store.send(.binding(.set(\.$searchField, mockDestinationWCords.name))) {
            $0.searchField = self.mockDestinationWCords.name
        }
        
        await store.send(.view(.onFindAddressComponentCalled))
        
        await store.receive(.internal(.handleAddressList(addressList))) {
            $0.searchResult = self.addressList
        }
        
        guard let mockAddress = mockDestinationWCords.address else {
            XCTFail()
            return
        }
        
        await store.send(.view(.onAddressRowTapped(mockDestinationWCords))) { [self] in
            $0.latitude = mockDestinationWCords.latitude
            $0.longitude = mockDestinationWCords.longitude
            $0.destinationNameField = mockDestinationWCords.name
            $0.addressField = mockAddress
            $0.isMarked = true
            $0.searchField = ""
            $0.searchResult = []
        }
    }
    
    func testSearchAddressFailed() async {
        let store = TestStore(initialState: DestinationFormReducer.State()) {
            DestinationFormReducer()
        } withDependencies: {
            $0.locationRepository.fetchLocation = { _ in throw CsError.URLError.invalidURLError }
        }
        
        await store.send(.internal(.handleAddressList(addressList))) {
            $0.searchResult = self.addressList
        }
        
        await store.send(.binding(.set(\.$searchField, mockDestinationWCords.name))) {
            $0.searchField = self.mockDestinationWCords.name
        }
        
        await store.send(.view(.onFindAddressComponentCalled))
        
        await store.receive(.internal(.handleAddressList([]))) {
            $0.searchResult = []
        }
    }
    
    func testAddDestinationSuccess() async {
        let store = TestStore(initialState: DestinationFormReducer.State()) {
            DestinationFormReducer()
        }
        
        await store.send(.binding(.set(\.$destinationNameField, mockDestination.name))) {
            $0.destinationNameField = self.mockDestination.name
        }
        
        guard let mockAddress = mockDestinationWCords.address else {
            XCTFail()
            return
        }
        
        await store.send(.binding(.set(\.$addressField, mockAddress))) {
            $0.addressField = mockAddress
        }
        
        await store.send(.view(.onAddDestinationButtonTapped))
        
        await store.receive(.internal(.handleAddDestination))
        
        await store.receive(.external(.onDestinationAdded(mockDestination)))
    }
    
    func testAddDestinationFailure() async {
        let store = TestStore(initialState: DestinationFormReducer.State()) {
            DestinationFormReducer()
        }
        
        await store.send(.view(.onAddDestinationButtonTapped)) {
            $0.alertState = .init(title: {
                .init("Fill the form!")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Okay")
                }
            }, message: {
                .init("Please state the destination name.")
            })
        }
        
        await store.send(.alertAction(.dismiss)) {
            $0.alertState = nil
        }
    }

    
}
