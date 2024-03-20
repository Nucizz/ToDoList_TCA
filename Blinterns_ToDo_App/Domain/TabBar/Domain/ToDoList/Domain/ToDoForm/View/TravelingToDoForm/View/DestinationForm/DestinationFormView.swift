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
        VStack(alignment: .leading, spacing: 15) {
            Map()
            
            DestinationNameField()
            
            AddressField()
            
            CsRectangleButton(title: "Add Destination") {
                store.send(.view(.onAddDestinationButtonTapped))
            }
            
            Spacer()
        }
        .padding(.horizontal, 15)
        .alert(
            store: store.scope(
                state: \.$alertState,
                action: { .alertAction($0) }
            )
        )
    }
}

extension DestinationFormView {
    
    @ViewBuilder private func Map() -> some View {
        WithViewStore(self.store, observe: { (isMarked: $0.isMarked, latitude: $0.latitude, longitude: $0.longitude) }, removeDuplicates: ==) { mapViewStore in
            MapView(
                isMarked: mapViewStore.state.isMarked,
                latitude: mapViewStore.state.latitude,
                longitude: mapViewStore.state.longitude
            )
            .overlay(alignment: .top) {
                VStack(spacing: 0) {
                    HStack(spacing: 15) {
                        SearchField()
                        CsRectangleButton(title: "Search") {
                            store.send(.view(.onFindAddressComponentCalled))
                        }
                        .frame(maxWidth: 80)
                    }
                    SearchAddressResult()
                }
                .padding(15)
            }
            .frame(maxHeight: 500)
            .cornerRadius(5)
        }
    }
    
    @ViewBuilder private func AddressField() -> some View {
        WithViewStore(self.store, observe: \.addressField) { addressViewStore in
            CsTextEditor(
                text: addressViewStore.binding(
                    get: { $0 },
                    send: { .binding(.set(\.$addressField, $0)) }
                ),
                placeholder: "Address"
            )
        }
    }
    
    @ViewBuilder private func DestinationNameField() -> some View {
        WithViewStore(self.store, observe: \.destinationNameField) { destinationNameViewStore in
            CsTextField(
                text: destinationNameViewStore.binding(
                    get: { $0 },
                    send: { .binding(.set(\.$destinationNameField, $0)) }
                ),
                placeholder: "Destination Name",
                keyboardType: .default
            )
        }
    }
    
    @ViewBuilder private func SearchField() -> some View {
        WithViewStore(self.store, observe: \.searchField) { searchViewStore in
            TextField(
                "Search Area",
                text: searchViewStore.binding(
                    get: { $0 },
                    send: { .binding(.set(\.$searchField, $0)) }
                )
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(.background)
            .cornerRadius(5)
            .onChange(of: searchViewStore.state) {
                store.send(.view(.onFindAddressComponentCalled))
            }
            .onSubmit {
                store.send(.view(.onFindAddressComponentCalled))
            }
        }
    }
    
    @ViewBuilder private func SearchAddressResult() -> some View {
        WithViewStore(self.store, observe: \.searchResult) { searchResultViewStore in
            if !searchResultViewStore.state.isEmpty {
                List {
                    ForEach(searchResultViewStore.state, id: \.self) { item in
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
    }
    
    @ViewBuilder private func AddressRow(item: Destination) -> some View {
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
