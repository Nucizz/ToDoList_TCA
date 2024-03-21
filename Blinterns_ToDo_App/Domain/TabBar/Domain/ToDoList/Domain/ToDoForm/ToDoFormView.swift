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
            WithViewStore(self.store, observe: \.isEditing) { isEditingViewStore in
                VStack(alignment: .leading) {
                    
                    Text("To-Do Configuration")
                        .font(.title2)
                        .bold()
                    
                    TitleTextField()
                        .padding(.bottom, 5)
                    
                    DescriptionTextField()
                        .padding(.bottom, 5)
                    
                    DeadlineTimeField()
                        .padding(.bottom, 5)
                    
                    CategorySelectorField(isEditing: isEditingViewStore.state)
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
                    
                    CsRectangleButton(title: isEditingViewStore.state ? "Update To-Do" : "Add To-Do") {
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
            store.send(.view(.onCategoryFieldSelected))
        }
    }
}

extension ToDoFormView {
    
    @ViewBuilder private func TitleTextField() -> some View {
        WithViewStore(self.store, observe: \.titleField) { titleViewStore in
            CsTextField(
                text: titleViewStore.binding(
                    get: { $0 },
                    send: { .binding(.set(\.$titleField, $0)) }
                ),
                placeholder: "Title",
                keyboardType: .default
            )
        }
    }
    
    @ViewBuilder private func DescriptionTextField() -> some View {
        WithViewStore(self.store, observe: \.descriptionField) { descriptionViewStore in
            CsTextEditor(
                text: descriptionViewStore.binding(
                    get: { $0 },
                    send: { .binding(.set(\.$descriptionField, $0)) }
                ),
                placeholder: "Description"
            )
        }
    }
    
    @ViewBuilder private func DeadlineTimeField() -> some View {
        WithViewStore(self.store, observe: \.isDeadlineTimeActive) { isDeadlineActiveViewStore in
            HStack {
                WithViewStore(self.store, observe: \.deadlineTimeField) { deadlineTimeViewStore in
                    DatePicker(selection:
                        deadlineTimeViewStore.binding(
                            get: { $0 },
                            send: { .binding(.set(\.$deadlineTimeField, $0)) }
                        )
                    ) {
                        Text("Set a Deadline")
                            .foregroundColor(.gray)
                    }
                    .disabled(!isDeadlineActiveViewStore.state)
                }
                
                Toggle(isOn:
                    isDeadlineActiveViewStore.binding(
                        get: { $0 },
                        send: { .binding(.set(\.$isDeadlineTimeActive, $0)) }
                    )
                ) {
                    
                }
                .toggleStyle(CustomCheckbox())
            }
        }
    }
    
    @ViewBuilder private func CategorySelectorField(isEditing: Bool) -> some View {
        HStack(alignment: .center) {
            Text("Select a Category")
                .foregroundColor(.gray)
            
            Spacer()
            
            WithViewStore(self.store, observe: \.categoryValueField) { categoryValueViewStore in
                Picker("To-Do Category",
                       selection: categoryValueViewStore.binding(
                            get: { $0 },
                            send: { .binding(.set(\.$categoryValueField, $0)) }
                       )
                ) {
                    ForEach(ToDoCategory.allCases, id: \.self) { category in
                        if category != .all {
                            Text(category.rawValue)
                                .tag(category.rawValue)
                        }
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: categoryValueViewStore.state) {
                    store.send(.view(.onCategoryFieldSelected))
                }
                .disabled(isEditing)
            }
        }
        
    }
    
}

#Preview {
    ToDoFormView(store: Store(initialState: ToDoFormReducer.State()) {
        ToDoFormReducer()._printChanges()
    })
}
