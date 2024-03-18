//
//  RootReducer.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import Foundation
import ComposableArchitecture


extension RootReducer {
    @ReducerBuilder<State, Action>
    var core: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onAppear:
                if date.now.timeIntervalSince1970 > userDefaultRepository.fetchExpireTime() {
                    return .run { send in
                        try await Task.sleep(for: .seconds(1))
                        await send(.presentLoginAlert)
                    }
                }
                return .run { send in
                    try await Task.sleep(for: .seconds(2))
                    await send(.initTabBarView)
                }
            case .initTabBarView:
                state.tabBarState = .init()
                return .none
            case .tabBarAction(let action):
                switch action {
                case .dismiss:
                    state.tabBarState = nil
                    return .none
                case .presented(let action):
                    switch action {
                    case .external(let action):
                        switch action {
                        case .onLogout:
                            return .run { send in
                                await send(.tabBarAction(.dismiss))
                                await send(.presentLoginAlert)
                            }
                        }
                    default:
                        return .none
                    }
                }
            case .onLoginButtonTapped:
                userDefaultRepository.setUsername(state.nameField)
                userDefaultRepository.setExpireTime(Calendar.current.date(byAdding: .hour, value: 2, to: date.callAsFunction())!.timeIntervalSince1970)
                return .send(.initTabBarView)
            case .alertInternalBugWorkaround:
                //MARK: Issues going on with SwiftUI Alert button disabled initiation https://forums.developer.apple.com/forums/thread/737964
                state.nameField.removeAll()
                return .none
            case .presentLoginAlert:
                state.isLoginAlertPresented = true
                return .run { send in
                    try await Task.sleep(for: .milliseconds(800))
                    await send(.alertInternalBugWorkaround)
                }
            }
        }
    }
    
}
