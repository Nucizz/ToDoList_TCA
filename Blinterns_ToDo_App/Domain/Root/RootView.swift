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
            .loginFormAlert(with: store)
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

extension View {
    
    func loginFormAlert(with store: StoreOf<RootReducer>) -> some View {
        modifier(LoginFormAlert(store: store))
    }

}

struct LoginFormAlert: ViewModifier {
    let store: StoreOf<RootReducer>

    func body(content: Content) -> some View {
        WithViewStore(self.store, observe: { (nameField: $0.nameField, isLoginAlertPresented: $0.isLoginAlertPresented) } ,removeDuplicates: ==)  { loginAlertViewStore in
            ZStack {
                content
            }
            .alert(
                "Welcome!",
                isPresented: loginAlertViewStore.binding(
                    get:  \.isLoginAlertPresented,
                    send: { .binding(.set(\.$isLoginAlertPresented, $0)) }
                )
            ) {
                TextField(text: loginAlertViewStore.binding(
                    get: \.nameField,
                    send: { .binding(.set(\.$nameField, $0)) }
                )) {
                    Text("Your Name")
                }
                .autocorrectionDisabled()
                .foregroundColor(.black)
                Button("Login") {
                    store.send(.onLoginButtonTapped)
                }
                .disabled(loginAlertViewStore.state.nameField.isEmpty)
            } message: {
                Text("Please login to continue.")
            }
        }
    }
}

#Preview {
    RootView(store: Store(initialState: RootReducer.State()) {
        RootReducer()._printChanges()
    })
}
