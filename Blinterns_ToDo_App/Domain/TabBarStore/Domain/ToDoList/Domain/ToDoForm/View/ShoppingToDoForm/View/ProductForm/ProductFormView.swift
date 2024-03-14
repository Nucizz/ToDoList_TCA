//
//  ShoppingFormView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 03-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct ProductFormView: View {
    let store: StoreOf<ProductFormReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            VStack(alignment: .leading) {
                CsImagePicker(selectedImage: viewStore.$productImageFile)
                    .padding(.bottom, 15)
                CsTextField(text: viewStore.$nameField, placeholder: "Product Name", keyboardType: .default)
                    .padding(.bottom, 15)
                CsTextField(text: viewStore.$productUrlField, placeholder: "Product Link", keyboardType: .URL)
                    .padding(.bottom, 15)
                CsRectangleButton(title: "Add To List") {
                    store.send(.view(.onAddButtonTapped))
                }
                Spacer()
            }
            .padding(15)
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
    ProductFormView(store: Store(initialState: ProductFormReducer.State()) {
        ProductFormReducer()._printChanges()
    })
    .padding(15)
}
