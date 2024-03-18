//
//  ShoppingFormStore.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 03-03-2024.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct ProductFormReducer: ReducerProtocol {
    @Dependency(\.fileManagerRepository) var fileManagerRepository

    struct State: Equatable {
        @BindingState var nameField: String = ""
        @BindingState var productImageFile: UIImage?
        @BindingState var productUrlField: String = ""
        
        @PresentationState var alertState: AlertState<Action.AlertAction>?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case view(ViewAction)
        case `internal`(InternalAction)
        case external(ExternalAction)
        
        case alertAction(PresentationAction<AlertAction>)
        
        enum ViewAction: Equatable {
            case onAddButtonTapped
        }
        
        enum InternalAction: Equatable {
            case handleAddProduct
        }
        
        enum ExternalAction: Equatable {
            case onProductAdded(Product)
        }
        
        enum AlertAction: Equatable {
            case dismiss
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        core
    }
    
}
