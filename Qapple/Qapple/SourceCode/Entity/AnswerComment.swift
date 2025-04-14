//
//  AnswerComment.swift
//  Qapple
//
//  Created by 문인범 on 4/14/25.
//

import Foundation

// MARK: 임시 Entity
struct AnswerComment: Identifiable, Equatable {
    let id: Int
    let writeId: Int
    let writerGeneration: String
    let content: String
    var heartCount: Int
    var isLiked: Bool
    let isMine: Bool
    var isReport: Bool
    let createdAt: Date
    
    var anonymityId: Int
}
