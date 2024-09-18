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
        let number: Int
        let size: Int
        let content: [Content] // 답변 리스트
        let numberOfElements: Int
        let hasPrevious: Bool
        let hasNext: Bool
        
        struct Content: Codable, Hashable {
            let answerId: Int
            let writerId: Int
            let profileImage: String? // 프로필 이미지 URL
            let nickname: String // 닉네임
            let content: String // 답변 내용
            let isMine: Bool // 내가 작성한 답변인지 여부
            let isReported: Bool // 신고된 답변인지 여부
            let isLiked: Bool
            let writeAt: String
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
