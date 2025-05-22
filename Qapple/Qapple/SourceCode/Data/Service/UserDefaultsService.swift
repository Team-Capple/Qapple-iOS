//
//  UserDefaultsService.swift
//  Qapple
//
//  Created by 김민준 on 5/22/25.
//

import Foundation

/// UserDefaults 관리 객체
struct UserDefaultsService {
    
    @UserDefault(key: "reportedAnswerCommentIds", defaultValue: [])
    static var reportedAnswerCommentIds: [Int]
}

// MARK: - propertyWrapper

@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        } set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
