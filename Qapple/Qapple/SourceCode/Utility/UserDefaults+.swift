//
//  UserDefaults+.swift
//  Qapple
//
//  Created by 문인범 on 3/18/25.
//

import Foundation


extension UserDefaults {
    static var boardBlockedUsers: [Int] {
        get {
            UserDefaults.standard.array(forKey: "boardBlockedUsers") as? [Int] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "boardBlockedUsers")
        }
    }
    
    static var answerBlockedUsers: [String] {
        get {
            UserDefaults.standard.array(forKey: "answerBlockedUsers") as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "answerBlockedUsers")
        }
    }
}
