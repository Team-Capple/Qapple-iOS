//
//  UserDefaults+.swift
//  Qapple
//
//  Created by 문인범 on 3/18/25.
//

import Foundation


/**
 사용자 차단 UserDefaults
 */
extension UserDefaults {
    private var blockedUsers: [Int] {
        get {
            UserDefaults.standard.array(forKey: "boardBlockedUsers") as? [Int] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "boardBlockedUsers")
        }
    }
    
    /// 차단 사용자 추가
    static func addBlockedUser(_ userId: Int) {
        var current = self.standard.blockedUsers
        if current.contains(userId) { return }
        current.append(userId)
        self.standard.blockedUsers = current
    }
    
    /// 게시판 차단 필터링 메소드
    static func filterBoardBlockedUser(board: BulletinBoard) -> Bool {
        let blockedList = self.standard.blockedUsers
        if blockedList.isEmpty { return true }
        let result = !blockedList.contains(board.writerId)
        return result
    }
    
    /// 답변 차단 필터링 메소드
    static func filterAnswerBlockedUser(answer: Answer) -> Bool {
        let blockedList = self.standard.blockedUsers
        if blockedList.isEmpty { return true }
        let result = !blockedList.contains(answer.writerId)
        return result
    }
}
