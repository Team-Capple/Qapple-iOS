//
//  UserDefaults+.swift
//  Qapple
//
//  Created by 문인범 on 3/18/25.
//

import Foundation


extension UserDefaults {
    private var boardBlockedUsers: [Int] {
        get {
            UserDefaults.standard.array(forKey: "boardBlockedUsers") as? [Int] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "boardBlockedUsers")
        }
    }
    
    private var answerBlockedUsers: [String] {
        get {
            UserDefaults.standard.array(forKey: "answerBlockedUsers") as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "answerBlockedUsers")
        }
    }
    
    static func addBoardBlockedUser(_ userId: Int) {
        var current = self.standard.boardBlockedUsers
        if current.contains(userId) { return }
        current.append(userId)
        self.standard.boardBlockedUsers = current
    }
    
    static func filterBoardBlockedUser(board: BulletinBoard) -> Bool {
        let blockedList = self.standard.boardBlockedUsers
        if blockedList.isEmpty { return true }
        let result = !blockedList.contains(board.writerId)
        return result
    }
}
