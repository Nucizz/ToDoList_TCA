//
//  ToDoList_AppTests.swift
//  Blinterns_ToDo_AppTests
//
//  Created by Calvin Anacia Suciawan on 14-03-2024.
//

import XCTest
import ComposableArchitecture
@testable import Blinterns_ToDo_App

@MainActor
final class ToDoList_AppTests: XCTestCase {
    
    let generalToDo = AnyToDoModel(value: GeneralTodo(id: UUID(), title: "General Task 1", isFinished: false))
    let shoppingToDo = AnyToDoModel(value: ShoppingToDo(id: UUID(), title: "Shopping Task 1", isFinished: false, budget: 100.0))
    let travelingToDo = AnyToDoModel(value: TravelingToDo(id: UUID(), title: "Traveling Task 1", description: "Visit Paris", isFinished: true, budget: 500.0))
    let learningToDo = AnyToDoModel(value: LearningToDo(id: UUID(), title: "Learning Task 1", isFinished: false))
    
    private func getMockList() -> ([ToDoCategory : IdentifiedArrayOf<AnyToDoModel>], [ToDoCategory : [UUID]]) {
        var finishedToDoIdList: [ToDoCategory : [UUID]] = [
            .all: [UUID](),
            .general: [UUID](),
            .shopping: [UUID](),
            .traveling: [UUID](),
            .learning: [UUID]()
        ]
        
        var toDoList: [ToDoCategory : IdentifiedArrayOf<AnyToDoModel>] = [
            .all: IdentifiedArrayOf<AnyToDoModel>(),
            .general: IdentifiedArrayOf<AnyToDoModel>(),
            .shopping: IdentifiedArrayOf<AnyToDoModel>(),
            .traveling: IdentifiedArrayOf<AnyToDoModel>(),
            .learning: IdentifiedArrayOf<AnyToDoModel>()
        ]
        
        toDoList[.general]?.append(generalToDo)
        toDoList[.shopping]?.append(shoppingToDo)
        toDoList[.traveling]?.append(travelingToDo)
        toDoList[.learning]?.append(learningToDo)
        toDoList[.all]?.append(contentsOf: [generalToDo, shoppingToDo, travelingToDo, learningToDo])
        
        finishedToDoIdList[.traveling]?.append(travelingToDo.id)
        finishedToDoIdList[.all]?.append(contentsOf: [travelingToDo.id])
        
        return (toDoList, finishedToDoIdList)
    }

}

extension ToDoList_AppTests {
    
    func testToDoForm() async {
        let store = TestStore(
          initialState: ToDoListReducer.State()
        ) {
            ToDoListReducer()
        } withDependencies: {
            $0.date = { DateGenerator.constant(Date.now) }()
        }
        
        await store.send(.view(.onAddButtonTapped)) {
            $0.toDoFormState = .init()
        }
        
        await store.send(.toDoFormAction(.dismiss)) {
            $0.toDoFormState = nil
        }
        
    }
    
    func testFinishToDoCheckboxSuccess() async {
        let mockList = getMockList()
        let store = TestStore(
          initialState: ToDoListReducer.State(
            finishedToDoIdList: mockList.1,
            toDoList: mockList.0
          )
        ) {
            ToDoListReducer()
        } withDependencies: {
            $0.toDoRepository.updateToDo = { _ in }
        }
        
        await store.send(.view(.onFinishCheckboxToggled(generalToDo)))
        
        await store.receive(.internal(.handleFinishedListFilter(generalToDo))) { [self] in
            $0.finishedToDoIdList[.general]? = [
                generalToDo.id
            ]
            $0.finishedToDoIdList[.all]? = [
                travelingToDo.id,
                generalToDo.id
            ]
        }
        
        await store.send(.view(.onFinishCheckboxToggled(generalToDo)))
        
        await store.receive(.internal(.handleFinishedListFilter(generalToDo))) { [self] in
            $0.finishedToDoIdList[.general]? = []
            $0.finishedToDoIdList[.all]? = [
                travelingToDo.id
            ]
        }
    }
    
    func testFinishToDoCheckboxFailure() async {
        let mockList = getMockList()
        let store = TestStore(
          initialState: ToDoListReducer.State(
            finishedToDoIdList: mockList.1,
            toDoList: mockList.0
          )
        ) {
            ToDoListReducer()
        } withDependencies: {
            $0.toDoRepository.updateToDo = { _ in throw CsError.ToDoError.dataNotFound }
        }
        
        await store.send(.view(.onFinishCheckboxToggled(generalToDo))) {
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
        let mockList = getMockList()
        let store = TestStore(
          initialState: ToDoListReducer.State(
            finishedToDoIdList: mockList.1,
            toDoList: mockList.0
          )
        ) {
            ToDoListReducer()
        } withDependencies: {
            $0.toDoRepository.deleteToDo = { _ in }
        }
        
        await store.send(.view(.onDeleteButtonTapped)) {
            $0.finishedToDoIdList[.all]? = []
            $0.finishedToDoIdList[.traveling]? = []
            $0.toDoList[.all]? = [
                self.generalToDo,
                self.shoppingToDo,
                self.learningToDo
            ]
            $0.toDoList[.traveling]? = []
        }
        
    }
    
    func testDeleteToDoButtonFailure() async {
        let mockList = getMockList()
        let store = TestStore(
          initialState: ToDoListReducer.State(
            finishedToDoIdList: mockList.1,
            toDoList: mockList.0
          )
        ) {
            ToDoListReducer()
        } withDependencies: {
            $0.toDoRepository.deleteToDo = { _ in throw CsError.ToDoError.dataNotFound }
        }
        
        await store.send(.view(.onDeleteButtonTapped)) {
            $0.alertState = .init(title: {
                .init("Failed to delete todo!")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Continue")
                }
            }, message: {
                .init(CsError.ToDoError.dataNotFound.localizedDescription)
            })
        }
        
        await store.send(.alertAction(.dismiss)) {
            $0.alertState = nil
        }
        
    }
    
    func testToDoDetail() async {
        let mockList = getMockList()
        let store = TestStore(
          initialState: ToDoListReducer.State(
            finishedToDoIdList: mockList.1,
            toDoList: mockList.0
          )
        ) {
            ToDoListReducer()
        }
        
        await store.send(.view(.onRowViewBodyTapped(shoppingToDo))) {
            $0.toDoDetailState = .init(toDo: self.shoppingToDo)
        }
        
        await store.send(.toDoDetailAction(.dismiss)) {
            $0.toDoDetailState = nil
        }
    }
    
    func testOnToDoAdded() async {
        let store = TestStore(
          initialState: ToDoListReducer.State(
            toDoFormState: .init()
          )
        ) {
            ToDoListReducer()
        } withDependencies: {
            $0.date = { DateGenerator.constant(Date.now) }()
        }
        
        await store.send(.toDoFormAction(.presented(.external(.onToDoAdded(generalToDo))))) { [self] in
            $0.toDoList[.all]? = [generalToDo]
            $0.toDoList[.general]? = [generalToDo]
        }
        
        await store.receive(.toDoFormAction(.dismiss)) {
            $0.toDoFormState = nil
        }
    }
    
    func testOnToDoDeletedFromDetail() async {
        let mockList = getMockList()
        let store = TestStore(
          initialState: ToDoListReducer.State(
            finishedToDoIdList: mockList.1,
            toDoList: mockList.0,
            toDoDetailState: .init(toDo: generalToDo)
          )
        ) {
            ToDoListReducer()
        }
        
        await store.send(.toDoDetailAction(.presented(.external(.onToDoDeleted(generalToDo))))) { [self] in
            $0.toDoList[.all]? = [shoppingToDo, travelingToDo, learningToDo]
            $0.toDoList[.general]? = []
            $0.finishedToDoIdList[.all]? = [travelingToDo.id]
            $0.finishedToDoIdList[.general]? = []
        }
        
        await store.receive(.toDoDetailAction(.dismiss)) {
            $0.toDoDetailState = nil
        }
    }
    
    func testOnToDoFinishedFromDetail() async {
        let mockList = getMockList()
        let store = TestStore(
          initialState: ToDoListReducer.State(
            finishedToDoIdList: mockList.1,
            toDoList: mockList.0,
            toDoDetailState: .init(toDo: generalToDo)
          )
        ) {
            ToDoListReducer()
        }
        
        await store.send(.toDoDetailAction(.presented(.external(.onToDoIsFinishedToggled(generalToDo)))))
        
        await store.receive(.internal(.handleFinishedListFilter(generalToDo))) { [self] in
            $0.finishedToDoIdList[.all]? = [travelingToDo.id, generalToDo.id]
            $0.finishedToDoIdList[.general]? = [generalToDo.id]
        }
        
    }
    
    func testOnToDoUpdatedFromDetail() async {
        let newGeneralToDo = AnyToDoModel(value: GeneralTodo(id: self.generalToDo.id, title: "New General Task 1", description: "Updated todo that has a description.", isFinished: false))
        let mockList = getMockList()
        let store = TestStore(
          initialState: ToDoListReducer.State(
            finishedToDoIdList: mockList.1,
            toDoList: mockList.0,
            toDoDetailState: .init(toDo: generalToDo)
          )
        ) {
            ToDoListReducer()
        }
        
        XCTAssertEqual(self.generalToDo, store.state.toDoList[.general]?[0])
        
        await store.send(.toDoDetailAction(.presented(.external(.onToDoUpdated(newGeneralToDo))))) { [self] in
            $0.toDoList[.all]? = [newGeneralToDo, shoppingToDo, travelingToDo, learningToDo]
            $0.toDoList[.general]? = [newGeneralToDo]
        }
        
    }

    
}
