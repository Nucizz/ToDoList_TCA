//
//  LearningToDoDetailView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct LearningToDoDetailView: View {
    let store: StoreOf<LearningToDoDetailReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: \.toDo) { viewStore in
            VStack {
                VStack(alignment: .leading) {
                    Text("Your Learning Subject List")
                    if let subjectList = viewStore.subjectList {
                        ForEach(subjectList, id: \.self) { subject in
                            SubjectRowView(subject: subject)
                                .contentShape(Rectangle())
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LearningToDoDetailView(store: Store(initialState: LearningToDoDetailReducer.State(
        toDo: LearningToDo(
            id: UUID(),
            title: "Belajar SwiftUI",
            description: "Belajar biar jago coding di Blibli.",
            deadlineTime: Date.now,
            isFinished: false,
            subjectList: [
                Subject(title: "Learn SwiftUI", note: "Learn about property wrappers."),
                Subject(title: "Learn TCA for Swift", sourceUrl: "https://pointfree.com"),
            ]
        )
    )) {
        LearningToDoDetailReducer()._printChanges()
    })
}
