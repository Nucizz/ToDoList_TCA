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
            CsRectangleButton(title: "Logout", bgColor: .red) {
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
        let formatter = Formatter()
        WithViewStore(store.self, observe: \.weatherResponse) { weatherViewStore in
            if let data = weatherViewStore.state {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .center, spacing: 10) {
                        Text(data.weather.first?.main ?? "None")
                            .font(.title2)
                            .bold()
                        Text("\(formatter.formatTemperature(temperature: data.main.temp))")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Text(data.name)
                            .bold()
                            .foregroundColor(.secondary)
                        
                    }
                    VStack(alignment: .leading) {
                        
                        HStack(spacing: 10) {
                            Text("L: \(formatter.formatTemperature(temperature: data.main.tempMin))")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            Text("H: \(formatter.formatTemperature(temperature: data.main.tempMax))")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            Text("Feels: \(formatter.formatTemperature(temperature: data.main.feelsLike))")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                    }
                    Text("Visibility \(data.visibility/1000)KM")
                        .font(.callout)
                        .bold()
                        .foregroundColor(.secondary)
                    Text("Humidity \(data.main.humidity)%")
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
