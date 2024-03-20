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
        VStack(alignment: .leading) {
            ImagePickerField()
                .padding(.bottom, 15)
            
            NameField()
                .padding(.bottom, 15)
            
            ProductUrlField()
                .padding(.bottom, 15)
            
            CsRectangleButton(title: "Add To List") {
                store.send(.view(.onAddButtonTapped))
            }
            
            Spacer()
        }
        .padding(15)
        .alert(
            store: store.scope(
                state: \.$alertState,
                action: { .alertAction($0) }
            )
        )
    }
}

extension ProductFormView {
    
    @ViewBuilder private func ProductUrlField() -> some View {
        WithViewStore(self.store, observe: \.productUrlField) { productUrlViewStore in
            CsTextField(
                text: productUrlViewStore.binding(
                    get: { $0 },
                    send: { .binding(.set(\.$productUrlField, $0)) }
                ),
                placeholder: "Product Link",
                keyboardType: .URL
            )
        }
    }
    
    @ViewBuilder private func NameField() -> some View {
        WithViewStore(self.store, observe: \.nameField) { nameViewStore in
            CsTextField(
                text: nameViewStore.binding(
                    get: { $0 },
                    send: { .binding(.set(\.$nameField, $0)) }
                ),
                placeholder: "Product Name",
                keyboardType: .default
            )
        }
    }
    
    @ViewBuilder private func ImagePickerField() -> some View {
        WithViewStore(self.store, observe: \.productImageFile) { productImageFileViewStore in
            CsImagePicker(selectedImage: productImageFileViewStore.binding(
                get: { $0 },
                send: { .binding(.set(\.$productImageFile, $0)) }
            ))
        }
    }
    
}

#Preview {
    ProductFormView(store: Store(initialState: ProductFormReducer.State()) {
        ProductFormReducer()._printChanges()
    })
    .padding(15)
}
