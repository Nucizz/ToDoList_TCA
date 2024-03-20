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
            VStack(alignment: .leading) {
                CategoryPicker()
                    .padding(.top, 15)
                
                ToDoList()
            }
            .background(Color(UIColor.secondarySystemBackground))
            .navigationBarTitle("To-Do List", displayMode: .inline)
            .navigationBarItems(
                leading: TrashButton(),
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

extension ToDoListView {
    
    @ViewBuilder private func ToDoList() -> some View {
        WithViewStore(self.store, observe: { (toDoList: $0.toDoList, filterValue: $0.filterValue) }, removeDuplicates: ==) { toDoListViewStore in
            if let filteredList = toDoListViewStore.toDoList[toDoListViewStore.filterValue], !filteredList.isEmpty {
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
    
    @ViewBuilder private func CategoryPicker() -> some View {
        WithViewStore(self.store, observe: \.filterValue ) { filterViewStore in
            Picker("To-Do Category",
                   selection: filterViewStore.binding(
                    get: { $0 },
                    send: { .binding(.set(\.$filterValue, $0)) }
                   )
            ) {
                ForEach(ToDoCategory.allCases, id: \.self) { category in
                    Text(category.rawValue)
                        .tag(category.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: filterViewStore.state) {
                store.send(.view(.setCategoryFilter))
            }
            .padding(.horizontal, 15)
        }
    }
    
    @ViewBuilder private func TrashButton() -> some View {
        WithViewStore(self.store, observe: { (finishedToDoIdList: $0.finishedToDoIdList, filterValue: $0.filterValue) }, removeDuplicates: ==) { trashViewStore in
            if let obeservedFinishedToDoIdList = trashViewStore.finishedToDoIdList[trashViewStore.filterValue], !obeservedFinishedToDoIdList.isEmpty {
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
    }
    
}

#Preview {
    ToDoListView(store: Store(initialState: ToDoListReducer.State()) {
        ToDoListReducer()._printChanges()
    })
}
