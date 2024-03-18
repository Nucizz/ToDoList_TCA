//
//  RootView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: StoreOf<RootReducer>
    
    var body: some View {
        NavigationStack {
            WithViewStore(self.store, observe: {$0}) { viewStore in
                VStack(alignment: .center) {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                    Image("Text Logo")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 50)
                    Text("Todo List")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(80)
                .alert("Welcome!", isPresented: viewStore.$isLoginAlertPresented) {
                    TextField(text: viewStore.$nameField) {
                        Text("Your Name")
                    }
                    .autocorrectionDisabled()
                    .foregroundColor(.black)
                    Button("Login") {
                        store.send(.onLoginButtonTapped)
                    }
                    .disabled(viewStore.nameField.isEmpty)
                } message: {
                    Text("Please login to continue.")
                }
            }
            .navigationDestination(
                store: self.store.scope(
                    state: \.$tabBarState,
                    action: { .tabBarAction($0) }
                )
            ) { viewStore in
                TabBarView(store: viewStore)
                    .navigationBarBackButtonHidden()
                    .transition(.scale)
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
    
}

#Preview {
    RootView(store: Store(initialState: RootReducer.State()) {
        RootReducer()._printChanges()
    })
}
