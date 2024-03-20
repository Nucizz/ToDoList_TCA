//
//  LearningToDoFormView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct LearningToDoFormView: View {
    let store: StoreOf<LearningToDoFormReducer>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Learning Configuration")
                .font(.title2)
                .bold()
            
            SubjectList()
        }
        .sheet(
            store: self.store.scope(
                state: \.$addSubjectState,
                action: { .addSubjectAction($0) }
            )
        ) { viewStore in
            NavigationView {
                SubjectFormView(store: viewStore)
                    .navigationBarTitle("Add a Subject", displayMode: .inline)
                    .navigationBarItems(
                        leading: Button("Cancel") {
                            store.send(.addSubjectAction(.dismiss))
                        }
                    )
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

extension LearningToDoFormView {
    
    @ViewBuilder private func SubjectList() -> some View {
        VStack(alignment: .leading) {
            Button(action: {
                store.send(.view(.onAddSubjectButtonTapped))
            }) {
                HStack(alignment: .firstTextBaseline, spacing: 5) {
                    Image(systemName: "plus")
                    Text("Add new")
                    Spacer()
                }
                .foregroundColor(.accentColor)
            }
            .padding(15)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            
            WithViewStore(self.store, observe: \.subjectList) { subjectListViewStore in
                ForEach(subjectListViewStore.state.indices, id: \.self) { index in
                    SubjectRowView(subject: subjectListViewStore.state[index])
                        .padding(.horizontal, 15)
                        .padding(.bottom, 15)
                        .contentShape(Rectangle())
                        .onLongPressGesture {
                            store.send(.view(.subjectRowLongPressed(index)))
                        }
                }
            }
            
        }
        .background(.background)
        .frame(maxWidth: .infinity)
        .cornerRadius(5)
        .padding(.top, 15)
        
    }
    
}

#Preview {
    LearningToDoFormView(
        store: Store(initialState: LearningToDoFormReducer.State()) {
            LearningToDoFormReducer()._printChanges()
        }
    )
}
