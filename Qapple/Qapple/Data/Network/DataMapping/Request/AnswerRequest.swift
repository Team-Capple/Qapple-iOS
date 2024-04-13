//
//  AnswersOfQuestion.swift
//  Capple
//
//  Created by 김민준 on 3/8/24.
//

import Foundation

class AnswerRequest {
    
    /// 특정 질문에 대한 답변 요청 구조체
    struct AnswersOfQuestion {
        let questionId: Int
        let keyword: String? // 검색할 키워드
        let size: Int? // 조회 할 질문의 개수
    }
    
    /// 답변 등록 요청 구조체
    struct RegisterAnswer: Codable {
        let answer: String // 답변
        let tags: [String] // 태그
    }
    
    /// 답변 삭제 구조체
    struct DeleteAnswer: Codable {
        let answerId: Int
    }
}
