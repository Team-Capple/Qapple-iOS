//
//  TodayAnswerModel.swift
//  Capple
//
//  Created by ShimHyeonhee on 3/3/24.
//


import Foundation

struct ServerResponse: Codable {
    
    /// 답변 모아보기 조회 Response
    struct Answers: Codable {
        
        var answerInfos: [AnswersInfos]
        
        struct AnswersInfos: Codable {
            let answerId: Int
            var profileImage: String?
            var nickname: String
            var content: String
            var tags: String
            var isMyAnswer: Bool
            var isReported: Bool
            
            let isLike: Bool
            let likeCount: Int
            let commentCount: Int
            let writingDate: Date
        }
    }
}
