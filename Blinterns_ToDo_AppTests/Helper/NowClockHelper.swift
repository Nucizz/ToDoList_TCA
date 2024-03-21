//
//  NowClockHelper.swift
//  Blinterns_ToDo_AppTests
//
//  Created by Calvin Anacia Suciawan on 21-03-2024.
//

import Foundation

class NowClockHelper {
    func now() -> TimeInterval {
        return Date().timeIntervalSinceReferenceDate
    }

    func sleep(forTimeInterval timeInterval: TimeInterval) async {
        try? await Task.sleep(nanoseconds: UInt64(timeInterval * 1_000_000)) // Sleep in microseconds
    }

    // Additional methods and properties as needed
}
