//
//  UserDefaultRepository.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 13-03-2024.
//

import Foundation
import Dependencies

struct UserDefaultRepository {
    var fetchExpireTime: () -> Double
    var fetchUsername: () -> String
    let setExpireTime: (Double) -> Void
    let setUsername: (String) -> Void
    let deleteAll: () -> Void
}

extension UserDefaultRepository: DependencyKey {
    static var liveValue: UserDefaultRepository {
        return Self(
            fetchExpireTime: {
                return UserDefaults.standard.double(forKey: "expireTimestamp")
            },
            fetchUsername: {
                return UserDefaults.standard.string(forKey: "username") ?? "User"
            },
            setExpireTime: { expireTime in
                UserDefaults.standard.setValue(expireTime, forKey: "expireTimestamp")
            },
            setUsername: { username in
                UserDefaults.standard.setValue(username, forKey: "username")
            },
            deleteAll: {
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.removeObject(forKey: "expireTimestamp")
            }
        )
    }
}

extension DependencyValues {
    var userDefaultRepository: UserDefaultRepository {
        get { self[UserDefaultRepository.self] }
        set { self[UserDefaultRepository.self] = newValue }
    }
}
