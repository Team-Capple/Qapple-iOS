//
//  CommentResponse.swift
//  Qapple
//
//  Created by 문인범 on 9/4/24.
//

import Foundation


struct CommentResponse: Codable {
    
    // 댓글 조회 Response
    struct Comments: Codable {
        let number: Int
        let size: Int
        let content: [Comment]
        let numberOfElements: Int
        let hasPrevious: Bool
        let hasNext: Bool
    }
    
    struct Comment: Codable, Identifiable, Hashable {
        var id: Int
        var writerId: Int
        var content: String
        var heartCount: Int
        var isLiked: Bool
        var isMine: Bool
        var isReport: Bool
        var createdAt: String
        
        enum CodingKeys: String, CodingKey {
            case id = "boardCommentId"
            case writerId
            case content
            case heartCount
            case isLiked
            case isMine
            case isReport
            case createdAt
        }
        
        init(id: Int, writerId: Int, content: String, heartCount: Int, isLiked: Bool, isMine: Bool, isReport: Bool, createdAt: String) {
            self.id = id
            self.writerId = writerId
            self.content = content
            self.heartCount = heartCount
            self.isLiked = isLiked
            self.isMine = isMine
            self.isReport = isReport
            self.createdAt = createdAt
        }
    }
}
