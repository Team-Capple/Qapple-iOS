//
//  QuestionResponse.swift
//  Capple
//
//  Created by 김민준 on 3/6/24.
//

import Foundation

struct QuestionResponse {
    
    /// 메인 질문 조회 Response
    struct Questions: Codable {
        
        let questionInfos: [QuestionInfos]
        
        /// 질문 정보
        struct QuestionInfos: Codable {
            let questionId: Int
            let questionStatus: String
            let content: String
            let tag: String?
            let likeCount: Int?
            let commentCount: Int?
        }
    }
    
    // 질문 모아보기 조회 Response
    struct Questions: Codable {
        
        let questionInfos: [QuestionsInfos]?
    
        
        struct QuestionsInfos: Codable,Identifiable {
            var id: Int?
            var questionId: Int?
            var questionStatus: String?
            var content: String?
            var tag: String?
            var likeCount: Int?
            var commentCount: Int?
        }

    }

}
