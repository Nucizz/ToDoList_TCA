//
//  ShoppingToDoDetailStore.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 04-03-2024.
//

import Foundation
import ComposableArchitecture

struct ShoppingToDoDetailReducer: ReducerProtocol {
    
    struct State: Equatable {
        let toDo: ShoppingToDo
        
    }
    
    enum Action {
        
    }
    
    var body: some ReducerProtocol<State, Action> {
        core
    }
    
}
