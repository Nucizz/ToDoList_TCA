//
//  CsError.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 08-03-2024.
//

import Foundation

struct CsError {
    
    enum URLError: Error {
        case invalidURLError
    }
    
    enum ToDoError: Error {
        case dataNotFound
    }
    
    enum FileManagerError: Error  {
        case imageNotFound
        case imageCompressionFailure
        case invalidApplicationURL
        case pathFailure
    }
    
    enum JsonError: Error  {
        case conversionFailure
        case incompleteData
    }
}
