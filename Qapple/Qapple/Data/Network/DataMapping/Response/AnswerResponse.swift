//
//  AnswerResponse.swift
//  Capple
//
//  Created by 김민준 on 3/8/24.
//

import Foundation

struct AnswerResponse {
    
    /// 내가 작성한 답변 리스트 Response
    struct Answers: Codable {
        let memberAnswerInfos: [MemberAnswerInfos]
        
        struct MemberAnswerInfos: Codable {
            let questionId: Int
            let answerId: Int
            let nickname: String
            let profileImage: String
            let content: String
            let heartCount: Int
            let writeAt: String
        }
    }
    
    /// 특정 질문에 대한 답변 리스트 Response
    struct AnswersOfQuestion: Codable {
        let answerInfos: [AnswerInfos] // 답변 리스트
        
        struct AnswerInfos: Codable, Hashable {
            let answerId: Int // 답변 ID
            let profileImage: String? // 프로필 이미지 URL
            let nickname: String // 닉네임
            let content: String // 답변 내용
            let isMyAnswer: Bool // 내가 작성한 답변인지 여부
            let isReported: Bool // 신고된 답변인지 여부
        }
    }
    
    // 답변 등록
    struct RegisterAnswer: Codable {
        let answerId: Int // 답변 ID
    }
    
    // 답변 삭제
    struct DeleteAnswer: Codable {
        let answerId: Int // 답변 ID
    }
}
