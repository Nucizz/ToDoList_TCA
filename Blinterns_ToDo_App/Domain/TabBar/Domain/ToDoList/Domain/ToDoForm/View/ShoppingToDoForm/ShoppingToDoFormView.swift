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
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                Text("Shopping Configuration")
                    .font(.title2)
                    .bold()
                CsTextField(
                    text: viewStore.$budgetField,
                    placeholder: "Budget",
                    keyboardType: .decimalPad
                )
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
                    ForEach(viewStore.productList.indices, id: \.self) { index in
                        ProductRowView(product: viewStore.productList[index])
                            .padding(.horizontal, 15)
                            .padding(.bottom, 15)
                            .contentShape(Rectangle())
                            .onLongPressGesture {
                                store.send(.view(.productRowLongPressed(index)))
                            }
                    }
                }
                .background(.background)
                .frame(maxWidth: .infinity)
                .cornerRadius(5)
                .padding(.top, 15)
            }
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

#Preview {
    ShoppingToDoFormView(store: Store(initialState: ShoppingToDoFormReducer.State()) {
        ShoppingToDoFormReducer()._printChanges()
    })
    .padding(15)
    .background(Color(UIColor.secondarySystemBackground))
}
