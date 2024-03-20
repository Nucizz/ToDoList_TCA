//
//  ShoppingToDoView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 03-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct ShoppingToDoFormView: View {
    let store: StoreOf<ShoppingToDoFormReducer>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Shopping Configuration")
                .font(.title2)
                .bold()
            
            BudgetField()
            
            ProductList()
        }
        .sheet(
            store: self.store.scope(
                state: \.$addProductState,
                action: { .addProductAction($0) }
            )
        ) { viewStore in
            NavigationView {
                ProductFormView(store: viewStore)
                    .navigationBarTitle("Add a Product", displayMode: .inline)
                    .navigationBarItems(
                        leading: Button("Cancel") {
                            store.send(.addProductAction(.dismiss))
                        }
                    )
            }
        }
        .alert(
            store: store.scope(
                state: \.$alertState,
                action: { .alertAction($0) }
            )
        )
    }
}

extension ShoppingToDoFormView {
    
    @ViewBuilder private func ProductList() -> some View {
        VStack(alignment: .leading) {
            Button(action: {
                store.send(.view(.onAddProductButtonTapped))
            }) {
                HStack(alignment: .firstTextBaseline, spacing: 5) {
                    Image(systemName: "plus")
                    Text("Add new")
                    Spacer()
                }
                .foregroundColor(.accentColor)
            }
            .padding(15)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            
            WithViewStore(self.store, observe: \.productList) { productListViewStore in
                ForEach(productListViewStore.state.indices, id: \.self) { index in
                    ProductRowView(product: productListViewStore.state[index])
                        .padding(.horizontal, 15)
                        .padding(.bottom, 15)
                        .contentShape(Rectangle())
                        .onLongPressGesture {
                            store.send(.view(.productRowLongPressed(index)))
                        }
                }
            }
            
        }
        .background(.background)
        .frame(maxWidth: .infinity)
        .cornerRadius(5)
        .padding(.top, 15)

    }
    
    @ViewBuilder private func BudgetField() -> some View {
        WithViewStore(self.store, observe: \.budgetField) { budgetViewStore in
            CsTextField(
                text: budgetViewStore.binding(
                    get: { $0 },
                    send: { .binding(.set(\.$budgetField, $0)) }
                ),
                placeholder: "Budget",
                keyboardType: .decimalPad
            )
        }
    }
    
}

#Preview {
    ShoppingToDoFormView(store: Store(initialState: ShoppingToDoFormReducer.State()) {
        ShoppingToDoFormReducer()._printChanges()
    })
    .padding(15)
    .background(Color(UIColor.secondarySystemBackground))
}
