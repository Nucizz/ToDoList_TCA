//
//  ShoppingToDoReducer.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 03-03-2024.
//

import Foundation
import ComposableArchitecture

extension ShoppingToDoFormReducer {
    
    @ReducerBuilder<State, Action>
    var core: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            
            case .view(let action):
                switch action {
                case .onAddProductButtonTapped:
                    state.addProductState = .init()
                    return.none
                
                case .productRowLongPressed(let index):
                    state.alertState = .init(title: {
                        .init("Delete product!")
                    }, actions: {
                        ButtonState(action: .send(.dismiss)) {
                            .init("Cancel")
                        }
                        ButtonState(action: .send(.onDeleteProduct(index))) {
                            .init("Delete")
                        }
                    }, message: {
                        .init("Are you sure you want to delete this product?")
                    })
                    return .none
                }
            
            case .addProductAction(let action):
                switch action {
                case .dismiss:
                    state.addProductState = nil
                    return .none
                
                case .presented(let action):
                    switch action {
                    case .external(let action):
                        switch action {
                        case .onProductAdded(let newProduct):
                            state.productList.append(newProduct)
                            return .send(.addProductAction(.dismiss))
                        }
                    
                    default:
                        return .none
                    }
                }
            
            case .alertAction(let action):
                switch action {
                case .dismiss:
                    state.alertState = nil
                    return .none
                
                case .presented(let action):
                    switch action {
                    case .onDeleteProduct(let index):
                        try? fileManagerRepository.deleteImage(
                            state.productList[index].name
                        )
                        state.productList.remove(at: index)
                        return .send(.alertAction(.dismiss))
                    
                    default:
                        return .none
                    }
                }
            }
        }
    }
}
