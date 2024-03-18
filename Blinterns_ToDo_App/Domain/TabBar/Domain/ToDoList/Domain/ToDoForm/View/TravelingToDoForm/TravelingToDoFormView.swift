//
//  TravelingToDoFormView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 06-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct TravelingToDoFormView: View {
    let store: StoreOf<TravelingToDoFormReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                Text("Traveling Configuration")
                    .font(.title2)
                    .bold()
                CsTextField(
                    text: viewStore.$budgetField,
                    placeholder: "Budget",
                    keyboardType: .decimalPad
                )
                VStack(alignment: .leading) {
                    Button(action: {
                        store.send(.view(.onAddDestinationButtonTapped))
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
                    ForEach(viewStore.destinationList.indices, id: \.self) { index in
                        DestinationRowView(destination: viewStore.destinationList[index])
                            .padding(.horizontal, 15)
                            .padding(.bottom, 15)
                            .contentShape(Rectangle())
                            .onLongPressGesture {
                                store.send(.view(.destinationRowLongPressed(index)))
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
                state: \.$addDestinationState,
                action: { .addDestinationAction($0) }
            )
        ) { viewStore in
            NavigationView {
                DestinationFormView(store: viewStore)
                    .navigationBarTitle("Add a Destination", displayMode: .inline)
                    .navigationBarItems(
                        leading: Button("Cancel") {
                            store.send(.addDestinationAction(.dismiss))
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
    VStack {
        TravelingToDoFormView(store: Store(initialState: TravelingToDoFormReducer.State()) {
            TravelingToDoFormReducer()._printChanges()
        })
        Spacer()
    }
    .padding(15)
}
