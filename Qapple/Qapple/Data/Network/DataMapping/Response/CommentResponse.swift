//
//  CommentResponse.swift
//  Qapple
//
//  Created by 문인범 on 9/4/24.
//

import Foundation


struct CommentResponse: Codable {
    
    
    struct Comments: Codable {
        let boardCommentInfos: [Comment]
        
        struct Comment: Codable, Identifiable {
            var id: Int
            var name: String
            var content: String
            var heartCount: Int
            var isLiked: Bool
            var createdAt: String
            
            enum CodingKeys: String, CodingKey {
                case id = "boardCommentId"
                case name = "writer"
                case content
                case heartCount
                case isLiked
                case createdAt
            }
        }
    }
}
