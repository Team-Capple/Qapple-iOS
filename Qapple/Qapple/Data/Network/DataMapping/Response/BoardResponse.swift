//
//  BoardResponse.swift
//  Qapple
//
//  Created by Simmons on 9/3/24.
//

import Foundation

struct BoardResponse {
    
    // 카테고리별 게시글 조회 Response
    struct Boards: Codable {
        let total: Int
        let size: Int
        let content: [board]
        let numberOfElements: Int
        let threshold: String
        let hasNext: Bool
        
        struct board: Codable {
            let boardId: Int
            let writerId: Int
            let writerNickname: String
            let content: String
            let heartCount: Int
            let commentCount: Int
            let createdAt: String
            let isMine: Bool
            let isReported: Bool
            let isLiked: Bool
        }
    }
    
    struct SearchBoards: Codable {
        let total: Int?
        let size: Int
        let content: [board]
        let numberOfElements: Int
        let threshold: String
        let hasNext: Bool
        
        struct board: Codable {
            let boardId: Int
            let writerId: Int
            let writerNickname: String
            let content: String
            let heartCount: Int
            let commentCount: Int
            let createdAt: String
            let isMine: Bool
            let isReported: Bool
            let isLiked: Bool
        }
    }
    
    struct LikeBoard: Codable {
        let boardId: Int
        let isLiked: Bool
    }
    
    struct PostBoard: Codable {
        let boardId: Int
    }
    
    struct DeleteBoard: Codable {
        let boardId: Int
    }
}
