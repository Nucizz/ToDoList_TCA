//
//  LearningToDoDetailStore.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import Foundation
import ComposableArchitecture

struct LearningToDoDetailReducer: ReducerProtocol {
    
    struct State: Equatable {
        let toDo: LearningToDo
    }
     
    enum Action {

    }
    
    var body: some ReducerProtocol<State, Action> {
        core
    }
    
}
