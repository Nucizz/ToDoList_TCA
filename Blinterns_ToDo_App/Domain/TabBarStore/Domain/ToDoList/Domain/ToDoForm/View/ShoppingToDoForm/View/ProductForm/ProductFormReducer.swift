//
//  ShoppingFormReducer.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 03-03-2024.
//

import Foundation
import ComposableArchitecture

extension ProductFormReducer {
    
    @ReducerBuilder<State, Action>
    var core: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return.none
            case .view(let action):
                switch action {
                case .onAddButtonTapped:
                    if !state.nameField.isEmpty {
                        return .send(.internal(.handleAddProduct))
                    }
                    state.alertState = .init(title: {
                        .init("Fill the form!")
                    }, actions: {
                        ButtonState(action: .send(.dismiss)) {
                            .init("Okay")
                        }
                    }, message: {
                        .init("Please state the product name.")
                    })
                    return .none
                }
            case .internal(let action):
                switch action {
                case .handleAddProduct:
                    var newProduct = Product(name: state.nameField)
                    
                    if !state.productUrlField.isEmpty {
                        newProduct.storeUrl = state.productUrlField
                    }
                    
                    if state.productImageFile != nil {
                        guard let imagePath = FileManagerRepository().saveImage(image: state.productImageFile!) else {
                            state.alertState = .init(title: {
                                .init("Sorry...")
                            }, actions: {
                                ButtonState(action: .send(.dismiss)) {
                                    .init("Okay")
                                }
                            }, message: {
                                .init("Unable to save your image.")
                            })
                            return .none
                        }
                        newProduct.imagePath = imagePath
                    }
                    
                    return .send(.external(.onProductAdded(newProduct)))
                }
            case .external(let action):
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
