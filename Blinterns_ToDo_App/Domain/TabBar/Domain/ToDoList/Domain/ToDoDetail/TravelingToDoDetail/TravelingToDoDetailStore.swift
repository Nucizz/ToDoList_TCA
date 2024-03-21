//
//  TravelingToDoDetailStore.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import Foundation
import ComposableArchitecture

struct TravelingToDoDetailReducer: ReducerProtocol {
    
    struct State: Equatable {
        let destinationList: [Destination]?
        let formattedBudget: String
        
        init(toDo: TravelingToDo) {
            formattedBudget = Formatter().formatCurrency(value: toDo.budget)
            destinationList = toDo.destinationList
        }
    }
    
    enum Action: Equatable {
        
    }
    
    var body: some ReducerProtocol<State, Action> {
        core
    }
    
}
