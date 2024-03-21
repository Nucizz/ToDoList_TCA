//
//  Root_AppTests.swift
//  Blinterns_ToDo_AppTests
//
//  Created by Calvin Anacia Suciawan on 13-03-2024.
//

import XCTest
import ComposableArchitecture
@testable import Blinterns_ToDo_App

@MainActor
final class Root_AppTests: XCTestCase {
    
    func testFoundCredentialTrigger() async {
        let store = TestStore(
          initialState: RootReducer.State()
        ) {
          RootReducer()
        } withDependencies: {
            $0.userDefaultRepository.fetchExpireTime = { 1 }
            $0.userDefaultRepository.fetchUsername = { "User" }
            $0.date = { DateGenerator.constant(Date(timeIntervalSince1970: 0)) }()
            $0.mainQueue = .immediate
        }
        
        await store.send(.onAppear)
                        
        await store.receive(.initTabBarView) {
            $0.tabBarState = .init()
        }
    }

    func testLoginForm() async {
        let store = TestStore(
          initialState: RootReducer.State()
        ) {
          RootReducer()
        } withDependencies: {
            $0.userDefaultRepository.fetchExpireTime = { 0 }
            $0.date = { DateGenerator.constant(Date(timeIntervalSince1970: 1)) }()
            $0.mainQueue = .immediate
        }
        
        await store.send(.onAppear)
        
        await store.receive(.presentLoginAlert) {
            $0.isLoginAlertPresented = true
        }
        
        XCTAssertFalse(store.state.nameField.isEmpty)
                
        await store.receive(.alertInternalBugWorkaround) {
            $0.nameField = ""
        }
        
        let inputName = "Nucized"
        
        await store.send(.binding(.set(\.$nameField, inputName))) {
            $0.nameField = inputName
        }
                
        await store.send(.onLoginButtonTapped)
        
        XCTAssertEqual(store.dependencies.userDefaultRepository.fetchUsername(), inputName)

        await store.receive(.initTabBarView) {
            $0.tabBarState = .init()
        }
    }
    
    func testOnLogout() async {
        let store = TestStore(
          initialState: RootReducer.State(
            tabBarState: .init()
          )
        ) {
          RootReducer()
        } withDependencies: {
            $0.mainQueue = .immediate
        }
        
        await store.send(.tabBarAction(.presented(.external(.onLogout))))
                
        await store.receive(.tabBarAction(.dismiss)) {
            $0.tabBarState = nil
        }

        await store.receive(.presentLoginAlert) {
            $0.isLoginAlertPresented = true
        }
                
        await store.receive(.alertInternalBugWorkaround) {
            $0.nameField = ""
        }
    }

}
