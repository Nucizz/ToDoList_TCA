//
//  Formatter.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 04-03-2024.
//

import Foundation

struct Formatter {
    
    func formatDateTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    func formatCurrency(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
            
        if let formattedString = formatter.string(from: NSNumber(value: value)) {
            return formattedString
        } else {
            return "Rp"
        }
    }
    
    func formatTemperature(temperature: Double) -> String {
        return String(format: "%.1f°C", temperature)
    }
    
}
