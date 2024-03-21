//
//  ProductForm_AppTests.swift
//  Blinterns_ToDo_AppTests
//
//  Created by Calvin Anacia Suciawan on 18-03-2024.
//

import XCTest
import ComposableArchitecture
@testable import Blinterns_ToDo_App

@MainActor
final class ProductForm_AppTests: XCTestCase {

    let mockProduct = Product(name: "a Product", storeUrl: "https://google.com")
    let mockImage = UIImage(named: "Set an Image")
    
}

extension ProductForm_AppTests {
    
    func testAddProductButtonSuccess() async {
        let store = TestStore(initialState: ProductFormReducer.State()) {
            ProductFormReducer()
        }
        
        await store.send(.binding(.set(\.$nameField, mockProduct.name))) {
            $0.nameField = self.mockProduct.name
        }
        
        guard let mockStoreUrl = mockProduct.storeUrl else {
            XCTFail("Mock Product not available.")
            return
        }
        
        await store.send(.binding(.set(\.$productUrlField, mockStoreUrl))) {
            $0.productUrlField = mockStoreUrl
        }
        
        await store.send(.view(.onAddButtonTapped))
        
        await store.receive(.internal(.handleAddProduct))
        
        await store.receive(.external(.onProductAdded(mockProduct)))
    }
    
    func testAddProductButtonFailureName() async {
        let store = TestStore(initialState: ProductFormReducer.State()) {
            ProductFormReducer()
        }
        
        await store.send(.view(.onAddButtonTapped)) {
            $0.alertState = .init(title: {
                .init("Fill the form!")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Okay")
                }
            }, message: {
                .init("Please state the product name.")
            })
        }
        
        await store.send(.alertAction(.dismiss)) {
            $0.alertState = nil
        }
    }
    
    func testAddProductButtonFailureImage() async {
        let store = TestStore(initialState: ProductFormReducer.State()) {
            ProductFormReducer()
        } withDependencies: {
            $0.fileManagerRepository.saveImage = { _ in throw CsError.FileManagerError.imageCompressionFailure }
        }
        
        await store.send(.binding(.set(\.$nameField, mockProduct.name))) {
            $0.nameField = self.mockProduct.name
        }
        
        await store.send(.binding(.set(\.$productImageFile, mockImage))) {
            $0.productImageFile = self.mockImage
        }
        
        await store.send(.view(.onAddButtonTapped))
        
        await store.receive(.internal(.handleAddProduct)) {
            $0.alertState = .init(title: {
                .init("Sorry...")
            }, actions: {
                ButtonState(action: .send(.dismiss)) {
                    .init("Okay")
                }
            }, message: {
                .init(CsError.FileManagerError.imageCompressionFailure.localizedDescription)
            })
        }
        
        await store.send(.alertAction(.dismiss)) {
            $0.alertState = nil
        }
    }
    
}
