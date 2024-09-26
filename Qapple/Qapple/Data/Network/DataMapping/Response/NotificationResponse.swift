//
//  NotificationResponse.swift
//  Qapple
//
//  Created by 김민준 on 9/21/24.
//

import Foundation

struct NotificationResponse {
    
    struct FetchNotificationResponse: Codable {
        let number: Int
        let size: Int
        let content: [Content]
        let numberOfElements: Int
        let hasPrevious: Bool
        let hasNext: Bool
        
        struct Content: Codable {
            let title: String
            let subtitle: String?
            let content: String?
            let boardId: String?
            let questionId: String?
            let boardCommentId: String?
            let createdAt: String
        }
    }
}
