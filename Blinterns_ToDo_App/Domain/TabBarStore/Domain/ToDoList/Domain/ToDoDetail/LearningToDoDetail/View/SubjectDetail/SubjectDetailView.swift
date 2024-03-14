//
//  SubjectDetailView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import SwiftUI
import ComposableArchitecture

struct SubjectDetailReducer: ReducerProtocol {
    
    struct State: Equatable {
        let subject: Subject
    }
    
    enum Action {
        case dismiss
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .dismiss:
                return .none
            }
        }
    }
    
}

struct SubjectDetailView: View {
    let store: StoreOf<SubjectDetailReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            OverlayVStack {
                HStack(alignment: .center) {
                    Text(viewStore.subject.title)
                        .font(.title)
                        .bold()
                    Spacer()
                    Button(
                        action: {
                            store.send(.dismiss)
                        }
                    ) {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                    }
                }
                
                if let sourceUrl = viewStore.subject.sourceUrl {
                    Text(sourceUrl)
                        .font(.callout)
                        .underline()
                        .foregroundColor(.blue)
                }
                
                if let note = viewStore.subject.note {
                    Text(note)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
        }
        
    }
}

#Preview {
    SubjectDetailView(store:
        Store(initialState: SubjectDetailReducer.State(
            subject: Subject(
                title: "Hello",
                sourceUrl: "https://google.com",
                note: "Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger."
            )
        )) {
            SubjectDetailReducer()._printChanges()
        }
    )
}
