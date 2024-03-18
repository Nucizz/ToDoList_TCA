//
//  ToDoView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct ToDoListView: View {
    let store: StoreOf<ToDoListReducer>
    
    var body: some View {
        NavigationView {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack(alignment: .leading) {
                    Picker("To-Do Category",
                           selection: viewStore.$filterValue
                    ) {
                        ForEach(ToDoCategory.allCases, id: \.self) { category in
                            Text(category.rawValue)
                                .tag(category.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: viewStore.filterValue) {
                        store.send(.view(.setCategoryFilter))
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 15)
                    if let filteredList = viewStore.toDoList[viewStore.filterValue], !filteredList.isEmpty {
                        List {
                            ForEach(filteredList, id: \.self) { toDo in
                                ToDoListCardView(
                                    toDo: toDo,
                                    onChecked: { updatedToDo in
                                        store.send(.view(.onFinishCheckboxToggled(updatedToDo)))
                                    },
                                    onTapped: {
                                        store.send(.view(.onRowViewBodyTapped(toDo)))
                                    }
                                )
                            }
                            .deleteDisabled(true)
                        }
                    } else {
                        VStack(alignment: .center) {
                            Image(systemName: "list.bullet.clipboard.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75)
                                .foregroundColor(.gray)
                            Text("To-do list is empty.")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(.top, 15)
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                    }
                }
            }
            .background(Color(UIColor.secondarySystemBackground))
            .navigationBarTitle("To-Do List", displayMode: .inline)
            .navigationBarItems(
                leading: {
                    WithViewStore(self.store, observe: {$0}) { viewStore in
                        if !viewStore.finishedToDoIdList[viewStore.filterValue]!.isEmpty {
                            Button(action: {
                                store.send(.view(.onDeleteButtonTapped))
                            }) {
                                Image(systemName: "trash")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }(),
                trailing: Button(action: {
                    store.send(.view(.onAddButtonTapped))
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
            )
        }
        .navigationDestination(
            store: self.store.scope(
                state: \.$toDoFormState,
                action: { .toDoFormAction($0) }
            )
        ) { viewStore in
            ToDoFormView(store: viewStore)
        }
        .navigationDestination(
            store: self.store.scope(
                state: \.$toDoDetailState,
                action: { .toDoDetailAction($0) }
            )
        ) { viewStore in
            ToDoDetailView(store: viewStore)
                .navigationBarItems(
                    trailing: Button("Edit") {
                        store.send(.toDoDetailAction(.presented(.view(.onEditButtonTapped))))
                    }
                )
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
    ToDoListView(store: Store(initialState: ToDoListReducer.State()) {
        ToDoListReducer()._printChanges()
    })
}
