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
        
        let boards: [board]
        
        struct board: Codable {
            var boardId: Int
            var writerId: Int
            var content: String
            var heartCount: Int
            var commentCount: Int
            var createAt: String
            // TODO: api 추가
        }
    }
    
    struct SearchBoards: Codable {
        var boardId: Int
        var writerId: Int
        var content: String
        var heartCount: Int
        var commentCount: Int
        var createAt: String
    }
}
