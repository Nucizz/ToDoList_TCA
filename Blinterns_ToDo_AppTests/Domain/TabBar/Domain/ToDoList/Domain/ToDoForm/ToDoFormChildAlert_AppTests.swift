//
//  ToDoFormChildAlert_AppTests.swift
//  Blinterns_ToDo_AppTests
//
//  Created by Calvin Anacia Suciawan on 18-03-2024.
//

import XCTest
import ComposableArchitecture
@testable import Blinterns_ToDo_App

@MainActor
final class ToDoFormChildAlert_AppTests: XCTestCase {
    
    let deleteIndex = 0

    let shoppingToDoValue = ShoppingToDo(
        id: UUID(),
        title: "Shopping Task 1",
        description: "Buy more bitcoinnn",
        isFinished: false,
        budget: 12500,
        productList: [
            Product(name: "bliblii eiiii")
        ]
    )
    
    let travelingToDoValue = TravelingToDo(
        id: UUID(),
        title: "Traveling Task 1",
        description: "Visit Kim Jong Un",
        isFinished: false,
        budget: 12500,
        destinationList: [
            Destination(name: "Korut")
        ]
    )
    
    let learningToDoValue = LearningToDo(
        id: UUID(),
        title: "Learning Task 1",
        description: "Stop procastination!",
        isFinished: false,
        subjectList: [
            Subject(title: "Swipt")
        ]
    )
    
}

extension ToDoFormChildAlert_AppTests {
    
    func testOnDeleteProduct() async {
        let store = TestStore(initialState: ShoppingToDoFormReducer.State(
            toDo: shoppingToDoValue
        )) {
            ShoppingToDoFormReducer()
        } withDependencies: {
            $0.fileManagerRepository.deleteImage = { _ in }
        }
        
        await store.send(.view(.productRowLongPressed(deleteIndex))) {
            $0.alertState = .init(title: {
                .init("Delete product!")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Cancel")
                }
                ButtonState(action: .send(.onDeleteProduct(self.deleteIndex))) {
                    .init("Delete")
                }
            }, message: {
                .init("Are you sure you want to delete this product?")
            })
        }
        
        await store.send(.alertAction(.presented(.onDeleteProduct(deleteIndex)))) {
            $0.productList = []
        }
        
        await store.receive(.alertAction(.dismiss)) {
            $0.alertState = nil
        }
    }
    
    func testOnDeleteDestination() async {
        let store = TestStore(initialState: TravelingToDoFormReducer.State(
            toDo: travelingToDoValue
        )) {
            TravelingToDoFormReducer()
        }
        
        await store.send(.view(.destinationRowLongPressed(deleteIndex))) {
            $0.alertState = .init(title: {
                .init("Delete destination!")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Cancel")
                }
                ButtonState(action: .send(.onDeleteDestination(self.deleteIndex))) {
                    .init("Delete")
                }
            }, message: {
                .init("Are you sure you want to delete this destination?")
            })
        }
        
        await store.send(.alertAction(.presented(.onDeleteDestination(deleteIndex)))) {
            $0.destinationList = []
        }
        
        await store.receive(.alertAction(.dismiss)) {
            $0.alertState = nil
        }
    }
    
    func testOnDeleteSubject() async {
        let store = TestStore(initialState: LearningToDoFormReducer.State(
            toDo: learningToDoValue
        )) {
            LearningToDoFormReducer()
        }
        
        await store.send(.view(.subjectRowLongPressed(deleteIndex))) {
            $0.alertState = .init(title: {
                .init("Delete subject!")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Cancel")
                }
                ButtonState(action: .send(.onDeleteSubject(self.deleteIndex))) {
                    .init("Delete")
                }
            }, message: {
                .init("Are you sure you want to delete this subject?")
            })
        }
        
        await store.send(.alertAction(.presented(.onDeleteSubject(deleteIndex)))) {
            $0.subjectList = []
        }
        
        await store.receive(.alertAction(.dismiss)) {
            $0.alertState = nil
        }
    }


    
}
