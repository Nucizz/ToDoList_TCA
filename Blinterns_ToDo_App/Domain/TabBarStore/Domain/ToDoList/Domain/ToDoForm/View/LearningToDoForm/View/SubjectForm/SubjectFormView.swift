//
//  SubjectFormView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct SubjectFormView: View {
    let store: StoreOf<SubjectFormReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            VStack {
                CsTextField(text: viewStore.$titleField, placeholder: "Subject Title", keyboardType: .default)
                CsTextField(text: viewStore.$sourceUrlField, placeholder: "Source Link", keyboardType: .URL)
                CsTextEditor(text: viewStore.$noteField, placeholder: "Notes")
                CsRectangleButton(title: "Add Subject") {
                    store.send(.view(.onAddSubjectButtonTapped))
                }
                Spacer()
            }
            .padding(.horizontal, 15)
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
    SubjectFormView(store: Store(initialState: SubjectFormReducer.State()) {
        SubjectFormReducer()._printChanges()
    })
}
