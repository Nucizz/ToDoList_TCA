//
//  ToDoDetail_AppTests.swift
//  Blinterns_ToDo_AppTests
//
//  Created by Calvin Anacia Suciawan on 18-03-2024.
//

import XCTest
import ComposableArchitecture
@testable import Blinterns_ToDo_App

@MainActor
final class ToDoDetail_AppTests: XCTestCase {
    let mockToDo = AnyToDoModel(value: GeneralTodo(id: UUID(), title: "General Task 1", isFinished: false))
}

extension ToDoDetail_AppTests {
    
    func testDynamicDetailInitialization() async {
        let generalToDo = mockToDo
        let shoppingToDo = AnyToDoModel(value: ShoppingToDo(id: UUID(), title: "Shopping Task 1", isFinished: false, budget: 100.0))
        let travelingToDo = AnyToDoModel(value: TravelingToDo(id: UUID(), title: "Traveling Task 1", description: "Visit Paris", isFinished: true, budget: 500.0))
        let learningToDo = AnyToDoModel(value: LearningToDo(id: UUID(), title: "Learning Task 1", isFinished: false))
        
        let generalStore = TestStore(initialState: ToDoDetailReducer.State(toDo: generalToDo)) {
            ToDoDetailReducer()
        }
        
        await generalStore.send(.internal(.handleToDoTypeDetail))
        
        await generalStore.finish()
        
        let shoppingStore = TestStore(initialState: ToDoDetailReducer.State(toDo: shoppingToDo)) {
            ToDoDetailReducer()
        }
        
        await shoppingStore.send(.internal(.handleToDoTypeDetail)) {
            if let toDo = shoppingToDo.getValue() as? ShoppingToDo {
                $0.shoppingToDoDetailState = .init(toDo: toDo)
            }
        }
        
        await shoppingStore.finish()
        
        let travelingStore = TestStore(initialState: ToDoDetailReducer.State(toDo: travelingToDo)) {
            ToDoDetailReducer()
        }
        
        await travelingStore.send(.internal(.handleToDoTypeDetail)) {
            if let toDo = travelingToDo.getValue() as? TravelingToDo {
                $0.travellingToDoDetailState = .init(toDo: toDo)
            }
        }
        
        await travelingStore.finish()
        
        let learningStore = TestStore(initialState: ToDoDetailReducer.State(toDo: learningToDo)) {
            ToDoDetailReducer()
        }
        
        await learningStore.send(.internal(.handleToDoTypeDetail)) {
            if let toDo = learningToDo.getValue() as? LearningToDo {
                $0.learningToDoDetailState = .init(toDo: toDo)
            }
        }
        
        await learningStore.finish()
    }
    
    func testFinishToDoCheckButtonSuccess() async {
        var toDo = mockToDo
        
        let store = TestStore(initialState: ToDoDetailReducer.State(toDo: toDo)) {
            ToDoDetailReducer()
        } withDependencies: {
            $0.toDoRepository.updateToDo = { _ in }
        }
        
        await store.send(.view(.onFinishButtonToggled)) {
            $0.toDo.isFinished = true
        }
        
        toDo.isFinished = true
        await store.receive(.external(.onToDoIsFinishedToggled(toDo)))
    }
    
    func testFinishToDoCheckButtonFailure() async {
        var toDo = mockToDo
        
        let store = TestStore(initialState: ToDoDetailReducer.State(toDo: toDo)) {
            ToDoDetailReducer()
        } withDependencies: {
            $0.toDoRepository.updateToDo = { _ in throw CsError.ToDoError.dataNotFound }
        }
        
        await store.send(.view(.onFinishButtonToggled)) {
            $0.alertState = .init(title: {
                .init("Failed to finish todo!")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Okay")
                }
            }, message: {
                .init(CsError.ToDoError.dataNotFound.localizedDescription)
            })
        }
        
        await store.send(.alertAction(.dismiss)) {
            $0.alertState = nil
        }
    }
    
    func testDeleteToDoButtonSuccess() async {
        var toDo = mockToDo
        toDo.isFinished = true
        
        let store = TestStore(initialState: ToDoDetailReducer.State(toDo: toDo)) {
            ToDoDetailReducer()
        } withDependencies: {
            $0.toDoRepository.deleteToDo = { _ in }
        }
        
        await store.send(.view(.onDeleteButtonTapped))
        
        await store.receive(.external(.onToDoDeleted(toDo)))
    }
    
    func testDeleteToDoButtonFailure() async {
        var toDo = mockToDo
        toDo.isFinished = true
        
        let store = TestStore(initialState: ToDoDetailReducer.State(toDo: toDo)) {
            ToDoDetailReducer()
        } withDependencies: {
            $0.toDoRepository.deleteToDo = { _ in throw CsError.ToDoError.dataNotFound }
        }
        
        await store.send(.view(.onDeleteButtonTapped)) {
            $0.alertState = .init(title: {
                .init("Failed to delete todo!")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Okay")
                }
            }, message: {
                .init(CsError.ToDoError.dataNotFound.localizedDescription)
            })
        }
        
        await store.send(.alertAction(.dismiss)) {
            $0.alertState = nil
        }
    }
    
    func testEditToDoButton() async {
        var toDo = mockToDo
        
        let store = TestStore(initialState: ToDoDetailReducer.State(toDo: toDo)) {
            ToDoDetailReducer()
        } withDependencies: {
            $0.date = { DateGenerator.constant(Date.now) }()
        }
        
        await store.send(.view(.onEditButtonTapped)) {
            $0.toDoFormState = .init(toDo: toDo)
        }
        
        toDo.title = "Lah kok berubah?!"
        await store.send(.toDoFormAction(.presented(.external(.onToDoEdited(toDo))))) {
            $0.toDo = toDo
            $0.toDoFormState = nil
        }
        
        await store.receive(.external(.onToDoUpdated(toDo)))
    }
    
}
