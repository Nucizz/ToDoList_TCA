//
//  ShoppingToDoDetailView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 04-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct ShoppingToDoDetailView: View {
    let store: StoreOf<ShoppingToDoDetailReducer>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Budget")
            FormattedBudgetText()
                .padding(.bottom, 15)
            
            ProductList()
        }
    }
}

extension ShoppingToDoDetailView {
    
    @ViewBuilder private func FormattedBudgetText() -> some View {
        WithViewStore(self.store, observe: \.formattedBudget) { formattedBudgetViewStore in
            Text(formattedBudgetViewStore.state)
                .font(.title2)
                .bold()
        }
    }
    
    @ViewBuilder private func ProductList() -> some View {
        WithViewStore(self.store, observe: \.productList) { productListViewStore in
            if let productList = productListViewStore.state {
                Text("Your Product List")
                ForEach(productList, id: \.self) { product in
                    ProductRowView(product: product)
                }
            }
        }
    }
    
}

#Preview {
    ShoppingToDoDetailView(store: Store(initialState: ShoppingToDoDetailReducer.State(
        toDo: ShoppingToDo(
            id: UUID(), 
            title: "Belanja di Blibli", 
            description: "Belanja hemat tanpa tipu-tipu",
            deadlineTime: Date.now,
            isFinished: false,
            budget: 32000,
            productList: [
                Product(name: "Macbook Pro M8 CSL"),
                Product(name: "Macbook Pro M4 Competition"),
                Product(name: "Macbook Air M340i"),
            ]
        )
    )) {
        ShoppingToDoDetailReducer()._printChanges()
    })
}
