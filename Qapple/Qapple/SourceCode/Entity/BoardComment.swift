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
    let writerGeneration: String
    let content: String
    var heartCount: Int
    var isLiked: Bool
    let isMine: Bool
    var isReport: Bool
    let createdAt: Date
    
    var anonymityId: Int
}
