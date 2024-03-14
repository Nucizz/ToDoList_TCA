//
//  Response.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 10-03-2024.
//

import Foundation

struct Response {
    let success: Bool
    let message: String?
    let data: Any?
    
    init(success: Bool, message: String? = nil, data: Any? = nil) {
        self.success = success
        self.message = message
        self.data = data
    }
}
