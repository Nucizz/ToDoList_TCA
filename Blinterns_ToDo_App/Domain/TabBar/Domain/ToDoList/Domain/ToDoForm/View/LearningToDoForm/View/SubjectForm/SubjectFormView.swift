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
        VStack {
            TitleField()
            SourceField()
            NoteField()
            CsRectangleButton(title: "Add Subject") {
                store.send(.view(.onAddSubjectButtonTapped))
            }
            Spacer()
        }
        .padding(.horizontal, 15)
        .alert(
            store: store.scope(
                state: \.$alertState,
                action: { .alertAction($0) }
            )
        )
    }
}

extension SubjectFormView {
    
    @ViewBuilder private func TitleField() -> some View {
        WithViewStore(self.store, observe: \.titleField) { titleViewStore in
            CsTextField(
                text: titleViewStore.binding(
                    get: { $0 },
                    send: { .binding(.set(\.$titleField, $0)) }
                ),
                placeholder: "Subject Title",
                keyboardType: .default
            )
        }
    }
    
    @ViewBuilder private func SourceField() -> some View {
        WithViewStore(self.store, observe: \.sourceUrlField) { sourceViewStore in
            CsTextField(
                text: sourceViewStore.binding(
                    get: { $0 },
                    send: { .binding(.set(\.$sourceUrlField, $0)) }
                ),
                placeholder: "Source Link",
                keyboardType: .URL
            )
        }
    }
    
    @ViewBuilder private func NoteField() -> some View {
        WithViewStore(self.store, observe: \.noteField) { noteViewStore in
            CsTextEditor(
                text: noteViewStore.binding(
                    get: { $0 },
                    send: { .binding(.set(\.$noteField, $0)) }
                ),
                placeholder: "Notes"
            )
        }
    }
    
}

#Preview {
    SubjectFormView(store: Store(initialState: SubjectFormReducer.State()) {
        SubjectFormReducer()._printChanges()
    })
}
