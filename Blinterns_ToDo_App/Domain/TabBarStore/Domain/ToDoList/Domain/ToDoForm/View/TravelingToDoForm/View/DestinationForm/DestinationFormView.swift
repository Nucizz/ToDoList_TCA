//
//  DestinationFormView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 06-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct DestinationFormView: View {
    let store: StoreOf<DestinationFormReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            VStack(alignment: .leading, spacing: 15) {
                MapView(isMarked: viewStore.$isMarked, latitude: viewStore.$latitude, longitude: viewStore.$longitude)
                    .overlay(alignment: .top) {
                        VStack(spacing: 0) {
                            HStack(spacing: 15) {
                                TextField("Search Area", text: viewStore.$searchField)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 10)
                                    .background(.background)
                                    .cornerRadius(5)
                                    .onChange(of: viewStore.searchField) {
                                        store.send(.view(.onFindAddressComponentCalled))
                                    }
                                    .onSubmit {
                                        store.send(.view(.onFindAddressComponentCalled))
                                    }
                                CsRectangleButton(title: "Search") {
                                    store.send(.view(.onFindAddressComponentCalled))
                                }
                                .frame(maxWidth: 80)
                            }
                            if !viewStore.searchResult.isEmpty {
                                List {
                                    ForEach(viewStore.searchResult, id: \.self) { item in
                                        AddressRow(item: item)
                                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                store.send(.view(.onAddressRowTapped(item)))
                                            }
                                    }
                                }
                                .padding(.horizontal, -20)
                                .scrollContentBackground(.hidden)
                            }
                        }
                        .padding(15)
                    }
                .frame(maxHeight: 500)
                .cornerRadius(5)
                CsTextField(
                    text: viewStore.$destinationNameField,
                    placeholder: "Destination Name",
                    keyboardType: .default
                )
                CsTextEditor(
                    text: viewStore.$addressField,
                    placeholder: "Address"
                )
                CsRectangleButton(title: "Add Destination") {
                    store.send(.view(.onAddDestinationButtonTapped))
                }
                Spacer()
            }
            .padding(.horizontal, 15)
        }
        .alert(
            store: store.scope(
                state: \.$alertState,
                action: { .alertAction($0) }
            )
        )
    }
}

extension DestinationFormView {
    
    @ViewBuilder func AddressRow(item: Destination) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(item.name)
                    .bold()
                Spacer()
            }
            if let address = item.address {
                Text(address)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
        }
    }
    
}

#Preview {
    DestinationFormView(store: Store(initialState: DestinationFormReducer.State()) {
        DestinationFormReducer()._printChanges()
    })
}
