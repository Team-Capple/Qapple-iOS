//
//  AnswerResponse.swift
//  Capple
//
//  Created by 김민준 on 3/8/24.
//

import Foundation

struct AnswerResponse {
    
    /// 특정 질문에 대한 답변 리스트 Response
    struct Search: Codable {
        let answerInfos: [AnswerInfos] // 답변 리스트
        
        struct AnswerInfos: Codable {
            let profileImage: String // 프로필 이미지 URL
            let nickname: String // 닉네임
            let content: String // 답변 내용
            let tags: String // 키워드
        }
    }
}
