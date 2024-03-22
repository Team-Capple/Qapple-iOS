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
        
        let questionInfos: [QuestionsInfos]?

        struct QuestionsInfos: Codable,Identifiable {
            var id: Int?
            var questionId: Int?
            var questionStatus: QuestionStatus?
            var livedAt: String?
            var content: String?
            var tag: String?
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
