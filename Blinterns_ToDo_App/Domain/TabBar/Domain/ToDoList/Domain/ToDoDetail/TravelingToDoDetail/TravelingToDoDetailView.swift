//
//  TravelingToDoDetailView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct TravelingToDoDetailView: View {
    let store: StoreOf<TravelingToDoDetailReducer>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Budget")
            FormattedBudgetText()
                .padding(.bottom, 15)
            
            DestinationList()
        }
    }
}

extension TravelingToDoDetailView {
    
    @ViewBuilder private func FormattedBudgetText() -> some View {
        WithViewStore(self.store, observe: \.formattedBudget) { formattedBudgetViewStore in
            Text(formattedBudgetViewStore.state)
                .font(.title2)
                .bold()
        }
    }
    
    @ViewBuilder private func DestinationList() -> some View {
        WithViewStore(self.store, observe: \.destinationList) { destinationListViewStore in
            if let destinationList = destinationListViewStore.state {
                Text("Your Destination List")
                ForEach(destinationList, id: \.self) { destination in
                    DestinationRowView(destination: destination)
                }
            }
        }
    }
    
}

#Preview {
    TravelingToDoDetailView(store: Store(initialState: TravelingToDoDetailReducer.State(
        toDo: TravelingToDo(
            id: UUID(),
            title: "Berangkat via Tiket",
            description: "Ticket murah hanya di tiket.com",
            deadlineTime: Date.now,
            isFinished: false,
            budget: 5600000,
            destinationList: [
                Destination(
                    name: "Blibli.com Head Office",
                    address: "Gedung Sarana Jaya, Gambir, Jakarta Pusat, DKI Jakarta, Indonesia"
                )
            ]
        )
    )){
        TravelingToDoDetailReducer()._printChanges()
    })
}
