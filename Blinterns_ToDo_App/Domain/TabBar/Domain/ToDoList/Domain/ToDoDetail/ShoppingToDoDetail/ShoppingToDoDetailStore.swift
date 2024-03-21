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
        let productList: [Product]?
        let formattedBudget: String
        
        init(toDo: ShoppingToDo) {
            formattedBudget = Formatter().formatCurrency(value: toDo.budget)
            productList = toDo.productList
        }
    }
    
    enum Action: Equatable {
        
    }
    
    var body: some ReducerProtocol<State, Action> {
        core
    }
    
}
