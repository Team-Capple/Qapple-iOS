//
//  BoardComment.swift
//  Qapple
//
//  Created by Simmons on 1/22/25.
//

import Foundation

struct BoardComment: Identifiable, Equatable {
    let id: Int
    let writeId: Int
    let content: String
    var heartCount: Int
    var isLiked: Bool
    let isMine: Bool
    var isReport: Bool
    let createdAt: Date
    
    var anonymityId: Int
    
    init(id: Int, writeId: Int, content: String, heartCount: Int, isLiked: Bool, isMine: Bool, isReport: Bool, createdAt: Date, anonymityId: Int) {
        self.id = id
        self.writeId = writeId
        self.content = content
        self.heartCount = heartCount
        self.isLiked = isLiked
        self.isMine = isMine
        self.isReport = isReport
        self.createdAt = createdAt
        self.anonymityId = anonymityId
    }
    
    init(id: Int, writeId: Int, content: String, heartCount: Int, isLiked: Bool, isMine: Bool, isReport: Bool, createdAt: Date) {
        self.id = id
        self.writeId = writeId
        self.content = content
        self.heartCount = heartCount
        self.isLiked = isLiked
        self.isMine = isMine
        self.isReport = isReport
        self.createdAt = createdAt
        self.anonymityId = -2
    }
}
