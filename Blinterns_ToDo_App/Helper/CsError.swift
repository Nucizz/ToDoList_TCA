//
//  CsError.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 08-03-2024.
//

import Foundation

struct CsError {
    
    enum ToDoError: Error {
        case dataNotFound
    }
    
    enum FileManagerError: Error  {
        case imageNotFound
    }
    
    enum JsonError: Error  {
        case conversionFailure
    }
}
