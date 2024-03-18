//
//  AddToDoView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 01-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct ToDoFormView: View {
    let store: StoreOf<ToDoFormReducer>
    
    var body: some View {
        ScrollView {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack(alignment: .leading) {
                    Text("To-Do Configuration")
                        .font(.title2)
                        .bold()
                    CsTextField(
                        text: viewStore.$titleField,
                        placeholder: "Title",
                        keyboardType: .default
                    )
                    .padding(.bottom, 5)
                    CsTextEditor(
                        text: viewStore.$descriptionField,
                        placeholder: "Description"
                    )
                    .padding(.bottom, 5)
                    CsDateField(
                        datetime: viewStore.$deadlineTimeField,
                        isActive: viewStore.$isDeadlineTimeActive,
                        title: "Set a Deadline"
                    )
                    .padding(.bottom, 5)
                    HStack(alignment: .center) {
                        Text("Select a Category")
                            .foregroundColor(.gray)
                        Spacer()
                        Picker("To-Do Category",
                               selection: viewStore.$categoryValueField
                        ) {
                            ForEach(ToDoCategory.allCases, id: \.self) { category in
                                if category != .all {
                                    Text(category.rawValue)
                                        .tag(category.rawValue)
                                }
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: viewStore.categoryValueField) {
                            store.send(.view(.onCategoryFieldSelected))
                        }
                        .disabled(viewStore.isEditing)
                    }
                    .padding(.bottom, 15)
                    
                    IfLetStore(store.scope(state: \.shoppingToDoFormState, action: ToDoFormReducer.Action.shoppingToDoFormAction)) { store in
                        ShoppingToDoFormView(store: store)
                        .padding(.top, 15)
                    }
                    
                    IfLetStore(store.scope(state: \.travelingToDoFormState, action: ToDoFormReducer.Action.travelingToDoFormAction)) { store in
                        TravelingToDoFormView(store: store)
                        .padding(.top, 15)
                    }
                    
                    IfLetStore(store.scope(state: \.learningToDoFormState, action: ToDoFormReducer.Action.learningToDoFormAction)) { store in
                        LearningToDoFormView(store: store)
                        .padding(.top, 15)
                    }
                    
                    CsRectangleButton(title: viewStore.isEditing ? "Update To-Do" : "Add To-Do") {
                        store.send(.view(.onAddOrEditButtonTapped))
                    }
                    .padding(.top, 15)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 15)
        .background(Color(UIColor.secondarySystemBackground))
        .alert(
            store: store.scope(
                state: \.$alertState,
                action: { .alertAction($0) }
            )
        )
        .onAppear {
            store.send(.internal(.handleCategoryInitiation))
        }
    }
}

#Preview {
    ToDoFormView(store: Store(initialState: ToDoFormReducer.State()) {
        ToDoFormReducer()._printChanges()
    })
}
