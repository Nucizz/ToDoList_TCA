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
        WithViewStore(self.store, observe: \.toDo) { viewStore in
            VStack(alignment: .leading) {
                Text("Your Budget")
                Text(Formatter().formatCurrency(value: viewStore.budget))
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 15)
                if let productList = viewStore.productList {
                    Text("Your Product List")
                    ForEach(productList, id: \.self) { product in
                        ProductRowView(product: product)
                    }
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
