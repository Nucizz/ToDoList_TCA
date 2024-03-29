//
//  ToDoDetailView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 04-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct ToDoDetailView: View {
    let store: StoreOf<ToDoDetailReducer>
    @State private var deleteButtonOpacity: CGFloat = 0.0
    @State private var lateTextOpacity: CGFloat = 0.0
    
    var body: some View {
        NavigationView {
            ScrollView {
                WithViewStore(store, observe: \.toDo) { viewStore in
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center) {
                            
                            Text(viewStore.state.title)
                                .font(.title)
                                .bold()
                                .padding(.vertical, 2)
                            
                            Spacer()
                            
                            if let deadlineTime = viewStore.state.deadlineTime,
                               deadlineTime <= Date.now && !viewStore.state.isFinished {
                                Text("Late")
                                    .font(.callout)
                                    .bold()
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 5)
                                    .foregroundColor(.white)
                                    .background(.red)
                                    .cornerRadius(5)
                                    .opacity(lateTextOpacity)
                                    .onAppear {
                                        withAnimation {
                                            lateTextOpacity = 1
                                        }
                                    }
                                    .onDisappear {
                                        withAnimation {
                                            lateTextOpacity = 0
                                        }
                                    }
                            }
                            
                            Text(viewStore.state.category.rawValue)
                                .font(.callout)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 5)
                                .background(viewStore.state.category.color)
                                .cornerRadius(5)
                        }
                        
                        if let deadlineTime = viewStore.state.deadlineTime {
                            HStack {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 16)
                                
                                Text(Formatter().formatDateTime(date: deadlineTime))
                                    .font(.callout)
                                    .bold()
                            }
                            .foregroundColor(.secondary)
                        }
                        
                        if viewStore.state.deadlineTime != nil &&
                            viewStore.state.description != nil { //MARK: For Better Padding UIUX
                            Spacer()
                                .frame(height: 30)
                        }
                        
                        if let description = viewStore.state.description {
                            Text(description)
                                .font(.callout)
                        }
                        
                        
                        IfLetStore(store.scope(state: \.shoppingToDoDetailState, action: ToDoDetailReducer.Action.shoppingToDoDetailAction)) { store in
                            ShoppingToDoDetailView(store: store)
                            .padding(.top, 15)
                        }
                        
                        IfLetStore(store.scope(state: \.travellingToDoDetailState, action: ToDoDetailReducer.Action.travelingToDoDetailAction)) { store in
                            TravelingToDoDetailView(store: store)
                            .padding(.top, 15)
                        }
                        
                        IfLetStore(store.scope(state: \.learningToDoDetailState, action: ToDoDetailReducer.Action.learningToDoDetailAction)) { store in
                            LearningToDoDetailView(store: store)
                            .padding(.top, 15)
                        }
                        
                        CsToggleRectangleButton(isActive: viewStore.state.isFinished) {
                            store.send(.view(.onFinishButtonToggled))
                        }
                        .padding(.top, 30)
                        
                        if viewStore.state.isFinished {                            
                            CsRectangleButton(title: "Delete To-Do", bgColor: .red) {
                                store.send(.view(.onDeleteButtonTapped))
                            }
                            .padding(.top, 15)
                            .opacity(deleteButtonOpacity)
                            .onAppear {
                                withAnimation {
                                    deleteButtonOpacity = 1
                                }
                            }
                            .onDisappear {
                                withAnimation {
                                    deleteButtonOpacity = 0
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(15)
                    .onAppear {
                        store.send(.internal(.handleToDoTypeDetail))
                    }
                }
            }
            .navigationDestination(
                store: self.store.scope(
                    state: \.$toDoFormState,
                    action: { .toDoFormAction($0) }
                )
            ) { viewStore in
                ToDoFormView(store: viewStore)
            }
            .alert(
                store: store.scope(
                    state: \.$alertState,
                    action: { .alertAction($0) }
                )
            )
        }
    }
}

#Preview {
    ToDoDetailView(store: Store(initialState: ToDoDetailReducer.State(
        toDo: AnyToDoModel(
            value: GeneralTodo(
                id: UUID(),
                title: "Training Blibli",
                description: "Creating a to-do list application in SwiftUI with The Composable Architecture",
                deadlineTime: Date.now,
                isFinished: false
            )
        )
    )) {
        ToDoDetailReducer()._printChanges()
    })
}
