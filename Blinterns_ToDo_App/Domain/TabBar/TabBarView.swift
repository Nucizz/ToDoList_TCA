//
//  TabBarView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct TabBarView: View {
    let store: StoreOf<TabBarReducer>
    
    init(store: StoreOf<TabBarReducer>) {
        self.store = store
        store.send(.internal(.initializeChildState))
    }
    
    var body: some View {
        WithViewStore(self.store, observe: \.selectedTab) { viewStore in
            TabView(
                selection: viewStore.binding(
                    get: { $0 },
                    send: { .binding(.set(\.$selectedTab, $0)) }
                )
            ) {
                
                DashboardView(
                    store: self.store.scope(state: \.dashboardState, action: { .dashboardAction($0) })
                )
                .tabItem {
                    Label("Dashboard", systemImage: "square.grid.2x2.fill")
                }
                .tag(TabBarReducer.Tab.dashboard)
                
                ToDoListView(
                    store: self.store.scope(state: \.toDoListState, action: { .toDoListAction($0) })
                )
                .tabItem {
                    Label("Your Todo", systemImage: "list.bullet.clipboard.fill")
                }
                .tag(TabBarReducer.Tab.toDoList)
                
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
    TabBarView(store: Store(initialState: TabBarReducer.State()) {
        TabBarReducer()._printChanges()
    })
}
