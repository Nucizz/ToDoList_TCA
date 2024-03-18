//
//  ToDoForm_AppTests.swift
//  Blinterns_ToDo_AppTests
//
//  Created by Calvin Anacia Suciawan on 15-03-2024.
//

import XCTest
import ComposableArchitecture
@testable import Blinterns_ToDo_App

@MainActor
final class ToDoForm_AppTests: XCTestCase {
    
    let constantDate = Date.now
    let constantId = UUID()
    let mockTitle = "Test Fake"
    let mockErrorBudget = "Not this"
    
    func getGeneralToDo() -> AnyToDoModel {
        return AnyToDoModel(value: GeneralTodo(
            id: constantId,
            title: "General Task 1",
            description: "Work work work",
            deadlineTime: constantDate,
            isFinished: false
        ))
    }
    
    func getShoppingToDo() -> AnyToDoModel {
        return AnyToDoModel(value: ShoppingToDo(
            id: constantId,
            title: "Shopping Task 1",
            description: "Buy more bitcoinnn",
            isFinished: false,
            budget: 12500,
            productList: [
                Product(name: "bliblii eiiii")
            ]
        ))
    }
    func getTravelingToDo() -> AnyToDoModel {
        return AnyToDoModel(value: TravelingToDo(
            id: constantId,
            title: "Traveling Task 1",
            description: "Visit Kim Jong Un",
            isFinished: false,
            budget: 12500,
            destinationList: [
                Destination(name: "Korut")
            ]
        ))
    }
    
    func getLearningToDo() -> AnyToDoModel {
        return AnyToDoModel(value: LearningToDo(
            id: constantId,
            title: "Learning Task 1",
            description: "Stop procastination!",
            isFinished: false,
            subjectList: [
                Subject(title: "Swipt")
            ]
        ))
    }

}

extension ToDoForm_AppTests { // MARK: FOR GENERAL USAGE
    
    func testCategoryDynamicFormInitiation() async {
        let store = TestStore(initialState: ToDoFormReducer.State()) {
            ToDoFormReducer()
        } withDependencies: {
            $0.date = { DateGenerator.constant(constantDate) }()
        }
        
        await store.send(.binding(.set(\.$categoryValueField, .shopping))) {
            $0.categoryValueField = .shopping
        }
        
        await store.send(.view(.onCategoryFieldSelected))
        
        await store.receive(.internal(.handleCategoryInitiation)) {
            $0.shoppingToDoFormState = .init()
        }
        
        await store.send(.binding(.set(\.$categoryValueField, .traveling))) {
            $0.categoryValueField = .traveling
        }
        
        await store.send(.view(.onCategoryFieldSelected)) {
            $0.shoppingToDoFormState = nil
        }
        
        await store.receive(.internal(.handleCategoryInitiation)) {
            $0.travelingToDoFormState = .init()
        }
        
        await store.send(.binding(.set(\.$categoryValueField, .learning))) {
            $0.categoryValueField = .learning
        }
        
        await store.send(.view(.onCategoryFieldSelected)) {
            $0.travelingToDoFormState = nil
        }
        
        await store.receive(.internal(.handleCategoryInitiation)) {
            $0.learningToDoFormState = .init()
        }
        
        await store.send(.binding(.set(\.$categoryValueField, .general))) {
            $0.categoryValueField = .general
        }
        
        await store.send(.view(.onCategoryFieldSelected)) {
            $0.learningToDoFormState = nil
        }
        
        await store.receive(.internal(.handleCategoryInitiation))
    }
    
    func testGeneralAddToDoButtonSuccess() async {
        let expectedNewToDo = getGeneralToDo()
        
        let store = TestStore(initialState: ToDoFormReducer.State()) {
            ToDoFormReducer()
        } withDependencies: {
            $0.date = { DateGenerator.constant(constantDate) }()
            $0.uuid = { UUIDGenerator.constant(constantId) }()
            $0.toDoRepository.createToDo = { _ in }
        }
        
        await store.send(.binding(.set(\.$titleField, expectedNewToDo.title))) {
            $0.titleField = expectedNewToDo.title
        }
        
        await store.send(.binding(.set(\.$descriptionField, expectedNewToDo.description!))) {
            $0.descriptionField = expectedNewToDo.description!
        }
        
        await store.send(.binding(.set(\.$isDeadlineTimeActive, true))) {
            $0.isDeadlineTimeActive = true
        }
        
        await store.send(.view(.onAddOrEditButtonTapped))
        
        await store.receive(.internal(.handleAddOrEdit(expectedNewToDo)))
        
        await store.receive(.external(.onToDoAdded(expectedNewToDo)))
    }
    
    func testShoppingAddToDoButtonSuccess() async {
        let expectedAnyNewToDo = getShoppingToDo()
        let expectedNewToDo = expectedAnyNewToDo.getValue() as! ShoppingToDo
        
        let store = TestStore(initialState: ToDoFormReducer.State()) {
            ToDoFormReducer()
        } withDependencies: {
            $0.date = { DateGenerator.constant(constantDate) }()
            $0.uuid = { UUIDGenerator.constant(constantId) }()
            $0.toDoRepository.createToDo = { _ in }
        }
        
        await store.send(.binding(.set(\.$categoryValueField, expectedNewToDo.category))) {
            $0.categoryValueField = expectedNewToDo.category
        }
        
        await store.send(.view(.onCategoryFieldSelected))
        
        await store.receive(.internal(.handleCategoryInitiation)) {
            $0.shoppingToDoFormState = .init()
        }
        
        await store.send(.binding(.set(\.$titleField, expectedNewToDo.title))) {
            $0.titleField = expectedNewToDo.title
        }
        
        await store.send(.binding(.set(\.$descriptionField, expectedNewToDo.description!))) {
            $0.descriptionField = expectedNewToDo.description!
        }
        
        await store.send(.shoppingToDoFormAction(.binding(.set(\.$budgetField, "\(expectedNewToDo.budget)")))) {
            $0.shoppingToDoFormState?.budgetField = "\(expectedNewToDo.budget)"
        }
        
        await store.send(.shoppingToDoFormAction(.view(.onAddProductButtonTapped))) {
            $0.shoppingToDoFormState!.addProductState = .init()
        }
        
        await store.send(.shoppingToDoFormAction(.addProductAction(.presented(.external(.onProductAdded(expectedNewToDo.productList!.first!)))))) {
            $0.shoppingToDoFormState!.productList = expectedNewToDo.productList!
        }
        
        await store.receive(.shoppingToDoFormAction(.addProductAction(.dismiss))) {
            $0.shoppingToDoFormState!.addProductState = nil
        }
        
        await store.send(.view(.onAddOrEditButtonTapped))
        
        await store.receive(.internal(.handleAddOrEdit(expectedAnyNewToDo)))
        
        await store.receive(.external(.onToDoAdded(expectedAnyNewToDo)))
    }

    func testTravellingAddToDoButtonSuccess() async {
        let expectedAnyNewToDo = getTravelingToDo()
        let expectedNewToDo = expectedAnyNewToDo.getValue() as! TravelingToDo
        
        let store = TestStore(initialState: ToDoFormReducer.State()) {
            ToDoFormReducer()
        } withDependencies: {
            $0.date = { DateGenerator.constant(constantDate) }()
            $0.uuid = { UUIDGenerator.constant(constantId) }()
            $0.toDoRepository.createToDo = { _ in }
        }
        
        await store.send(.binding(.set(\.$categoryValueField, expectedNewToDo.category))) {
            $0.categoryValueField = expectedNewToDo.category
        }
        
        await store.send(.view(.onCategoryFieldSelected))
        
        await store.receive(.internal(.handleCategoryInitiation)) {
            $0.travelingToDoFormState = .init()
        }
        
        await store.send(.binding(.set(\.$titleField, expectedNewToDo.title))) {
            $0.titleField = expectedNewToDo.title
        }
        
        await store.send(.binding(.set(\.$descriptionField, expectedNewToDo.description!))) {
            $0.descriptionField = expectedNewToDo.description!
        }
        
        await store.send(.travelingToDoFormAction(.binding(.set(\.$budgetField, "\(expectedNewToDo.budget)")))) {
            $0.travelingToDoFormState?.budgetField = "\(expectedNewToDo.budget)"
        }
        
        await store.send(.travelingToDoFormAction(.view(.onAddDestinationButtonTapped))) {
            $0.travelingToDoFormState!.addDestinationState = .init()
        }
        
        await store.send(.travelingToDoFormAction(.addDestinationAction(.presented(.external(.onDestinationAdded(expectedNewToDo.destinationList!.first!)))))) {
            $0.travelingToDoFormState!.destinationList = expectedNewToDo.destinationList!
        }
        
        await store.receive(.travelingToDoFormAction(.addDestinationAction(.dismiss))) {
            $0.travelingToDoFormState!.addDestinationState = nil
        }
        
        await store.send(.view(.onAddOrEditButtonTapped))
        
        await store.receive(.internal(.handleAddOrEdit(expectedAnyNewToDo)))
        
        await store.receive(.external(.onToDoAdded(expectedAnyNewToDo)))
    }

    func testLearningAddToDoButtonSuccess() async {
        let expectedAnyNewToDo = getLearningToDo()
        let expectedNewToDo = expectedAnyNewToDo.getValue() as! LearningToDo
        
        let store = TestStore(initialState: ToDoFormReducer.State()) {
            ToDoFormReducer()
        } withDependencies: {
            $0.date = { DateGenerator.constant(constantDate) }()
            $0.uuid = { UUIDGenerator.constant(constantId) }()
            $0.toDoRepository.createToDo = { _ in }
        }
        
        await store.send(.binding(.set(\.$categoryValueField, expectedNewToDo.category))) {
            $0.categoryValueField = expectedNewToDo.category
        }
        
        await store.send(.view(.onCategoryFieldSelected))
        
        await store.receive(.internal(.handleCategoryInitiation)) {
            $0.learningToDoFormState = .init()
        }
        
        await store.send(.binding(.set(\.$titleField, expectedNewToDo.title))) {
            $0.titleField = expectedNewToDo.title
        }
        
        await store.send(.binding(.set(\.$descriptionField, expectedNewToDo.description!))) {
            $0.descriptionField = expectedNewToDo.description!
        }
        
        await store.send(.learningToDoFormAction(.view(.onAddSubjectButtonTapped))) {
            $0.learningToDoFormState!.addSubjectState = .init()
        }
        
        await store.send(.learningToDoFormAction(.addSubjectAction(.presented(.external(.onSubjectAdded(expectedNewToDo.subjectList!.first!)))))) {
            $0.learningToDoFormState!.subjectList = expectedNewToDo.subjectList!
        }
        
        await store.receive(.learningToDoFormAction(.addSubjectAction(.dismiss))) {
            $0.learningToDoFormState!.addSubjectState = nil
        }
        
        await store.send(.view(.onAddOrEditButtonTapped))
        
        await store.receive(.internal(.handleAddOrEdit(expectedAnyNewToDo)))
        
        await store.receive(.external(.onToDoAdded(expectedAnyNewToDo)))
    }
    
    func testAddToDoButtonTitleFailure() async {
        let store = TestStore(initialState: ToDoFormReducer.State()) {
            ToDoFormReducer()
        } withDependencies: {
            $0.date = { DateGenerator.constant(constantDate) }()
            $0.uuid = { UUIDGenerator.constant(constantId) }()
            $0.toDoRepository.createToDo = { _ in }
        }
        
        await store.send(.view(.onAddOrEditButtonTapped)) {
            $0.alertState = .init(title: {
                .init("Fill the form!")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Okay")
                }
            }, message: {
                .init("Please state the to-do title.")
            })
        }
    }
    
    func testShoppingAddToDoButtonBudgetFailure() async {
        let store = TestStore(initialState: ToDoFormReducer.State()) {
            ToDoFormReducer()
        } withDependencies: {
            $0.date = { DateGenerator.constant(constantDate) }()
            $0.uuid = { UUIDGenerator.constant(constantId) }()
            $0.toDoRepository.createToDo = { _ in }
        }
        
        await store.send(.binding(.set(\.$categoryValueField, .shopping))) {
            $0.categoryValueField = .shopping
        }
        
        await store.send(.view(.onCategoryFieldSelected))
        
        await store.receive(.internal(.handleCategoryInitiation)) {
            $0.shoppingToDoFormState = .init()
        }
        
        await store.send(.binding(.set(\.$titleField, mockTitle))) {
            $0.titleField = self.mockTitle
        }
        
        await store.send(.view(.onAddOrEditButtonTapped)) {
            $0.alertState = .init(title: {
                .init("Fill the form!")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Okay")
                }
            }, message: {
                .init("Please state the shopping budget.")
            })
        }
        
        await store.send(.alertAction(.dismiss)) {
            $0.alertState = nil
        }
        
        await store.send(.shoppingToDoFormAction(.binding(.set(\.$budgetField, mockErrorBudget)))) {
            $0.shoppingToDoFormState!.budgetField = self.mockErrorBudget
        }
        
        await store.send(.view(.onAddOrEditButtonTapped)) {
            $0.alertState = .init(title: {
                .init("Invalid form statement!")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Okay")
                }
            }, message: {
                .init("Budget can only be decimal.")
            })
        }
    }
    
    func testTravellingAddToDoButtonBudgetFailure() async {
        let store = TestStore(initialState: ToDoFormReducer.State()) {
            ToDoFormReducer()
        } withDependencies: {
            $0.date = { DateGenerator.constant(constantDate) }()
            $0.uuid = { UUIDGenerator.constant(constantId) }()
            $0.toDoRepository.createToDo = { _ in }
        }
        
        await store.send(.binding(.set(\.$categoryValueField, .traveling))) {
            $0.categoryValueField = .traveling
        }
        
        await store.send(.view(.onCategoryFieldSelected))
        
        await store.receive(.internal(.handleCategoryInitiation)) {
            $0.travelingToDoFormState = .init()
        }
        
        await store.send(.binding(.set(\.$titleField, mockTitle))) {
            $0.titleField = self.mockTitle
        }
        
        await store.send(.view(.onAddOrEditButtonTapped)) {
            $0.alertState = .init(title: {
                .init("Fill the form!")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Okay")
                }
            }, message: {
                .init("Please state the traveling budget.")
            })
        }
        
        await store.send(.alertAction(.dismiss)) {
            $0.alertState = nil
        }
        
        await store.send(.travelingToDoFormAction(.binding(.set(\.$budgetField, mockErrorBudget)))) {
            $0.travelingToDoFormState!.budgetField = self.mockErrorBudget
        }
        
        await store.send(.view(.onAddOrEditButtonTapped)) {
            $0.alertState = .init(title: {
                .init("Invalid form statement!")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Okay")
                }
            }, message: {
                .init("Budget can only be decimal.")
            })
        }
    }
    
    func testGeneralAddToDoButtonFailure() async {
        let expectedNewToDo = getGeneralToDo()
        
        let store = TestStore(initialState: ToDoFormReducer.State()) {
            ToDoFormReducer()
        } withDependencies: {
            $0.uuid = { UUIDGenerator.constant(constantId) }()
            $0.date = { DateGenerator.constant(constantDate) }()
            $0.toDoRepository.createToDo = { _ in throw CsError.ToDoError.dataNotFound }
        }
        
        await store.send(.binding(.set(\.$titleField, expectedNewToDo.title))) {
            $0.titleField = expectedNewToDo.title
        }
        
        await store.send(.binding(.set(\.$descriptionField, expectedNewToDo.description!))) {
            $0.descriptionField = expectedNewToDo.description!
        }
        
        await store.send(.binding(.set(\.$isDeadlineTimeActive, true))) {
            $0.isDeadlineTimeActive = true
        }
                
        await store.send(.view(.onAddOrEditButtonTapped))
        
        await store.receive(.internal(.handleAddOrEdit(expectedNewToDo))) {
            $0.alertState = .init(title: {
                .init("Something Went Wrong")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Okay")
                }
            }, message: {
                .init(CsError.ToDoError.dataNotFound.localizedDescription)
            })
        }
    }


    
}

extension ToDoForm_AppTests { // MARK: FOR EDITING USAGE
    
    func testEditGeneralFormInitiation() async {
        let store = TestStore(initialState: ToDoFormReducer.State(
            toDo: getGeneralToDo()
        )) {
            ToDoFormReducer()
        } withDependencies: {
            $0.date = { DateGenerator.constant(constantDate) }()
        }
        
        await store.send(.internal(.handleCategoryInitiation))
    }
    
    func testEditShoppingFormInitiation() async {
        let expectedNewToDo = getShoppingToDo()
        let store = TestStore(initialState: ToDoFormReducer.State(
            toDo: expectedNewToDo
        )) {
            ToDoFormReducer()
        } withDependencies: {
            $0.date = { DateGenerator.constant(constantDate) }()
        }
        
        await store.send(.internal(.handleCategoryInitiation)) {
            $0.shoppingToDoFormState = .init(toDo: expectedNewToDo.getValue() as? ShoppingToDo)
        }
    }
    
    func testEditTravelingFormInitiation() async {
        let expectedNewToDo = getTravelingToDo()
        let store = TestStore(initialState: ToDoFormReducer.State(
            toDo: expectedNewToDo
        )) {
            ToDoFormReducer()
        } withDependencies: {
            $0.date = { DateGenerator.constant(constantDate) }()
        }
        
        await store.send(.internal(.handleCategoryInitiation)) {
            $0.travelingToDoFormState = .init(toDo: expectedNewToDo.getValue() as? TravelingToDo)
        }
    }
    
    func testEditLearningFormInitiation() async {
        let expectedNewToDo = getLearningToDo()
        let store = TestStore(initialState: ToDoFormReducer.State(
            toDo: expectedNewToDo
        )) {
            ToDoFormReducer()
        } withDependencies: {
            $0.date = { DateGenerator.constant(constantDate) }()
        }
        
        await store.send(.internal(.handleCategoryInitiation)) {
            $0.learningToDoFormState = .init(toDo: expectedNewToDo.getValue() as? LearningToDo)
        }
    }
    
    func testGeneralEditToDoButtonSuccess() async {
        let expectedNewToDo = getGeneralToDo()
        
        let store = TestStore(initialState: ToDoFormReducer.State(
            toDo: expectedNewToDo
        )) {
            ToDoFormReducer()
        } withDependencies: {
            $0.uuid = { UUIDGenerator.constant(constantId) }()
            $0.date = { DateGenerator.constant(constantDate) }()
            $0.toDoRepository.updateToDo = { _ in }
        }
        
        await store.send(.view(.onAddOrEditButtonTapped))
        
        await store.receive(.internal(.handleAddOrEdit(expectedNewToDo)))
        
        await store.receive(.external(.onToDoEdited(expectedNewToDo)))
    }
    
    func testGeneralEditToDoButtonFailure() async {
        let expectedNewToDo = getGeneralToDo()
        
        let store = TestStore(initialState: ToDoFormReducer.State(
            toDo: expectedNewToDo
        )) {
            ToDoFormReducer()
        } withDependencies: {
            $0.uuid = { UUIDGenerator.constant(constantId) }()
            $0.date = { DateGenerator.constant(constantDate) }()
            $0.toDoRepository.updateToDo = { _ in throw CsError.ToDoError.dataNotFound }
        }
        
        await store.send(.view(.onAddOrEditButtonTapped))
        
        await store.receive(.internal(.handleAddOrEdit(expectedNewToDo))) {
            $0.alertState = .init(title: {
                .init("Something Went Wrong")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Okay")
                }
            }, message: {
                .init(CsError.ToDoError.dataNotFound.localizedDescription)
            })
        }
    }
    
}
