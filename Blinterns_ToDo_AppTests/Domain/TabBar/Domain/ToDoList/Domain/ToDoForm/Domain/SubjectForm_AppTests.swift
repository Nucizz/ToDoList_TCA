//
//  SubjectForm_AppTests.swift
//  Blinterns_ToDo_AppTests
//
//  Created by Calvin Anacia Suciawan on 18-03-2024.
//

import XCTest
import ComposableArchitecture
@testable import Blinterns_ToDo_App

@MainActor
final class SubjectForm_AppTests: XCTestCase {
    let mockSubject = Subject(title: "Belajar Bitcoin", sourceUrl: "https://akademicrypto.com/courses/", note: "BTC.D masih turun")
}

extension SubjectForm_AppTests {
    
    func testAddSubjectSuccess() async {
        let store = TestStore(initialState: SubjectFormReducer.State()) {
            SubjectFormReducer()
        }
        
        await store.send(.binding(.set(\.$titleField, mockSubject.title))) {
            $0.titleField = self.mockSubject.title
        }
        
        guard let mockSourceUrl = mockSubject.sourceUrl else {
            XCTFail()
            return
        }
        
        await store.send(.binding(.set(\.$sourceUrlField, mockSourceUrl))) {
            $0.sourceUrlField = mockSourceUrl
        }
        
        guard let mockNote = mockSubject.note else {
            XCTFail()
            return
        }
        
        await store.send(.binding(.set(\.$noteField, mockNote))) {
            $0.noteField = mockNote
        }
        
        await store.send(.view(.onAddSubjectButtonTapped))
        
        await store.receive(.internal(.handleAddSubject))
        
        await store.receive(.external(.onSubjectAdded(mockSubject)))
    }
    
    func testAddSubjectFailure() async {
        let store = TestStore(initialState: SubjectFormReducer.State()) {
            SubjectFormReducer()
        }
        
        await store.send(.view(.onAddSubjectButtonTapped)) {
            $0.alertState = .init(title: {
                .init("Fill the form!")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Okay")
                }
            }, message: {
                .init("Please state the subject name.")
            })
        }
        
        await store.send(.alertAction(.dismiss)) {
            $0.alertState = nil
        }

    }
    
}
