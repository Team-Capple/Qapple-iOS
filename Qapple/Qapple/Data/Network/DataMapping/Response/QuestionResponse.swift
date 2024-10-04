//
//  QuestionResponse.swift
//  Capple
//
//  Created by 김민준 on 3/6/24.
//

import Foundation

struct QuestionResponse {
    
    // 질문 모아보기 조회 Response
    struct Questions: Codable {
        let total: Int
        let size: Int
        let content: [Content]
        let numberOfElements: Int
        let threshold: String
        let hasNext: Bool

        struct Content: Codable {
            var questionId: Int
            var questionStatus: String
            var livedAt: String?
            var content: String
            var isAnswered: Bool
        }
    }
    
    /// 오늘의 메인 질문
    struct MainQuestion: Codable {
        let questionId: Int
        let questionStatus: String
        let content: String
        let isAnswered: Bool
    }
}
