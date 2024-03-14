//
//  ShoppingToDoStore.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 03-03-2024.
//

import Foundation
import ComposableArchitecture

struct ShoppingToDoFormReducer: ReducerProtocol { 
    
    struct State: Equatable {
        @BindingState var budgetField: String = ""
        
        var productList: [Product] = []
        
        @PresentationState var addProductState: ProductFormReducer.State?
        @PresentationState var alertState: AlertState<Action.AlertAction>?
        
        init(toDo: ShoppingToDo? = nil) {
            if let toDoAttribute = toDo {
                self.budgetField = "\(toDoAttribute.budget)"
                self.productList = toDoAttribute.productList ?? []
            } else {
                self.budgetField = ""
                self.productList = []
            }
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case view(ViewAction)
        
        case addProductAction(PresentationAction<ProductFormReducer.Action>)
        case alertAction(PresentationAction<AlertAction>)
        
        enum ViewAction {
            case onAddProductButtonTapped
            case productRowLongPressed(Int)
        }
        
        enum AlertAction: Equatable {
            case dismiss
            case onDeleteProduct(Int)
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        core
            .self.ifLet(\.$addProductState, action: /Action.addProductAction) {
                ProductFormReducer()
            }
    }
    
}
