    //
    //  ToDoRepository.swift
    //  Blinterns_ToDo_App
    //
    //  Created by Calvin Anacia Suciawan on 14-03-2024.
    //

    import Foundation
    import CoreData
    import Dependencies

    struct ToDoRepository {
        var createToDo: (AnyToDoModel) throws -> Void
        var fetchToDo: () throws -> [AnyToDoModel]
        var updateToDo: (AnyToDoModel) throws -> Void
        var deleteToDo: (UUID) throws -> Void
    }

    extension ToDoRepository {
        static private func getContext() -> NSManagedObjectContext {
            let persistentContainer: NSPersistentContainer = {
                let container = NSPersistentContainer(name: "CoreDatabase")
                container.loadPersistentStores { description, error in
                    if let error = error {
                        fatalError("Failed to load Core Data stack: \(error)")
                    }
                }
                return container
            }()
            
            return persistentContainer.viewContext
        }
        
        static private func jsonString(jsonData: Data) throws -> String {
            if let encodedString = String(data: jsonData, encoding: .utf8) {
                return encodedString
            }
            throw CsError.JsonError.conversionFailure
        }
    }

extension ToDoRepository: DependencyKey {
    static var liveValue: ToDoRepository {
        return Self(
            createToDo: { toDo in
                let context = getContext()
                let jsonObject: Document = Document(context: context)
                let encoder = JSONEncoder()
                var jsonData: Data
                
                switch toDo.category {
                case .shopping:
                    jsonData = try encoder.encode(toDo.getValue() as! ShoppingToDo)
                    break
                case .traveling:
                    jsonData = try encoder.encode(toDo.getValue() as! TravelingToDo)
                    break
                case .learning:
                    jsonData = try encoder.encode(toDo.getValue() as! LearningToDo)
                    break
                default:
                    jsonData = try encoder.encode(toDo.getValue() as! GeneralTodo)
                    break
                }
                
                jsonObject.id = toDo.id
                jsonObject.category = toDo.category.rawValue
                jsonObject.json = try jsonString(jsonData: jsonData)
                try context.save()
            },
            fetchToDo: {
                let context = getContext()
                let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
                
                let jsonArray = try context.fetch(fetchRequest)
                let decoder = JSONDecoder()
                
                let toDoList = try jsonArray.compactMap { jsonObject -> AnyToDoModel? in
                    
                    guard let jsonData = jsonObject.json?.data(using: .utf8) else {
                        throw CsError.JsonError.conversionFailure
                    }
                    
                    switch ToDoCategory.init(rawValue: jsonObject.category!) {
                    case .shopping:
                         return AnyToDoModel(
                            value: try decoder.decode(ShoppingToDo.self, from: jsonData)
                         )
                    case .traveling:
                        return AnyToDoModel(
                           value: try decoder.decode(TravelingToDo.self, from: jsonData)
                        )
                    case .learning:
                        return AnyToDoModel(
                           value: try decoder.decode(LearningToDo.self, from: jsonData)
                        )
                    default:
                        return AnyToDoModel(
                           value: try decoder.decode(GeneralTodo.self, from: jsonData)
                        )
                    }
                }
                
                return toDoList
            },
            updateToDo: { toDo in
                let context = getContext()
                let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", toDo.id as CVarArg)
                
                if let jsonObject = try context.fetch(fetchRequest).first {
                    
                    let encoder = JSONEncoder()
                    var jsonData: Data
                    
                    switch toDo.category {
                    case .shopping:
                        jsonData = try encoder.encode(toDo.getValue() as! ShoppingToDo)
                        break
                    case .traveling:
                        jsonData = try encoder.encode(toDo.getValue() as! TravelingToDo)
                        break
                    case .learning:
                        jsonData = try encoder.encode(toDo.getValue() as! LearningToDo)
                        break
                    default:
                        jsonData = try encoder.encode(toDo.getValue() as! GeneralTodo)
                        break
                    }
                    
                    jsonObject.json = try jsonString(jsonData: jsonData)
                    try context.save()
                }
            },
            deleteToDo: { id in
                let context = getContext()
                let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                
                if let jsonObject = try context.fetch(fetchRequest).first {
                    
                    guard let jsonData = jsonObject.json?.data(using: .utf8) else {
                        throw CsError.JsonError.conversionFailure
                    }
                    
                    if ToDoCategory.init(rawValue: jsonObject.category!) == .shopping {
                        let shoppingToDoValue = try JSONDecoder().decode(ShoppingToDo.self, from: jsonData)
                        
                        if let productList = shoppingToDoValue.productList {
                            for product in productList {
                                if let path = product.imagePath {
                                    if !FileManagerRepository().deleteImage(fileName: path) {
                                        throw CsError.FileManagerError.imageNotFound
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    context.delete(jsonObject)
                    try context.save()
                }
            }
        )
    }
}

extension DependencyValues {
    var toDoRepository: ToDoRepository {
        get { self[ToDoRepository.self] }
        set { self[ToDoRepository.self] = newValue }
    }
}
