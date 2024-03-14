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
        store.send(.initializeChildState)
    }
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            TabView(
                selection: viewStore.$selectedTab
            ) {
                
                DashboardView(
                    store: Store(initialState: viewStore.dashboardState) {
                        DashboardReducer()
                    }
                )
                .tabItem {
                    Label("Dashboard", systemImage: "square.grid.2x2.fill")
                }
                .tag(TabBarReducer.Tab.dashboard)
                
                ToDoListView(
                    store: Store(initialState: viewStore.toDoListState) {
                        ToDoListReducer()
                    }
                )
                .tabItem {
                    Label("Your Todo", systemImage: "list.bullet.clipboard.fill")
                }
                .tag(TabBarReducer.Tab.toDoList)
                
            }
        }
    }
}

#Preview {
    TabBarView(store: Store(initialState: TabBarReducer.State()) {
        TabBarReducer()._printChanges()
    })
}
