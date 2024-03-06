//
//  QuestionResponse.swift
//  Capple
//
//  Created by 김민준 on 3/6/24.
//

import Foundation

struct QuestionResponse {
    
    /// 메인 질문 조회 Response
    struct AllQuestions: Codable {
        let questionId: Int
        let questionStatus: String
        let content: String
    }
}
