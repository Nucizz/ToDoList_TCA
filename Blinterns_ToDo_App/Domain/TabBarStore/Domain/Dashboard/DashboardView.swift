//
//  DashboardView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 08-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct DashboardView: View {
    let store: StoreOf<DashboardReducer>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            userGreetings()
            weatherWidget()
            CsRectangleButton(title: "Exit", bgColor: .red) {
                store.send(.view(.onLogoutButtonTapped))
            }
            Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.top, 10)
        .background(Color(UIColor.secondarySystemBackground))
    }
    
    @ViewBuilder func userGreetings() -> some View {
        WithViewStore(store.self, observe: \.name) { viewStore in
            VStack(alignment: .leading) {
                HStack {
                    Text("\(StringGenerator().getGreetings()),")
                        .font(.title2)
                        .bold()
                        .lineLimit(1)
                    Spacer()
                }
                Text(viewStore.state)
                    .font(.title)
                    .bold()
                    .lineLimit(1)
            }
        }
    }
    
    @ViewBuilder func weatherWidget() -> some View {
        WithViewStore(store.self, observe: \.weatherResponse) { viewStore in
            if viewStore.state != nil {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .center, spacing: 10) {
                        Text(viewStore.state!.weather.first!.main)
                            .font(.title2)
                            .bold()
                        Text("\(Formatter.formatTemperature(temperature: viewStore.state!.main.temp))")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Text(viewStore.state!.name)
                            .bold()
                            .foregroundColor(.secondary)
                        
                    }
                    VStack(alignment: .leading) {
                        
                        HStack(spacing: 10) {
                            Text("L: \(Formatter.formatTemperature(temperature: viewStore.state!.main.temp_min))")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            Text("H: \(Formatter.formatTemperature(temperature: viewStore.state!.main.temp_max))")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            Text("Feels: \(Formatter.formatTemperature(temperature: viewStore.state!.main.feels_like))")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                    }
                    Text("Visibility \(viewStore.state!.visibility/1000)KM")
                        .font(.callout)
                        .bold()
                        .foregroundColor(.secondary)
                    Text("Humidity \(viewStore.state!.main.humidity)%")
                        .font(.callout)
                        .bold()
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color(.systemBackground))
                .cornerRadius(5)
            } else {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding(.vertical, 15)
            }
        }
    }
    
}

#Preview {
    DashboardView(store: Store(initialState: DashboardReducer.State()) {
        DashboardReducer()._printChanges()
    })
}
