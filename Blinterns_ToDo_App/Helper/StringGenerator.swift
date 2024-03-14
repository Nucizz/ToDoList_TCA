//
//  StringGenerator.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 08-03-2024.
//

import Foundation

struct StringGenerator {
    
    func getGreetings() -> String {
        let currentHour = Calendar.current.component(.hour, from: Date())
        if currentHour <= 10 {
            return "Good Morning"
        } else if currentHour <= 18 {
            return "Good Afternoon"
        } else {
            return "Good Evening"
        }
    }
    
}
