//
//  QuestionRepository.swift
//  Qapple
//
//  Created by 김민준 on 1/23/25.
//

import ComposableArchitecture
import QappleRepository
import Foundation

struct QuestionRepository {
    var fetchQuestionList: (_ threshold: String?) async throws -> ([Question], QappleAPI.TotalCount, QappleAPI.PaginationInfo)
    var fetchMainQuestion: () async throws -> Question
}

// MARK: - DependencyKey

extension QuestionRepository: DependencyKey {
    
    static let liveValue = Self(
        fetchQuestionList: { threshold in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await QuestionAPI.fetchQuestionList(
                    threshold: threshold,
                    pageSize: 25,
                    server: server,
                    accessToken: accessToken
                )
            }
            
            let result = response.content.map {
                Question(
                    id: $0.questionId,
                    content: $0.content,
                    publishedDate: $0.livedAt?.ISO8601ToDate(.yearMonthDateTime) ?? .now,
                    isAnswered: $0.isAnswered,
                    isLived: $0.questionStatus == ("LIVE")
                )
            }
            let paginationInfo = QappleAPI.PaginationInfo(
                threshold: response.threshold,
                hasNext: response.hasNext
            )
            
            return (result, response.total, paginationInfo)
        },
        fetchMainQuestion: {
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await QuestionAPI.fetchMainQuestion(
                    server: server,
                    accessToken: accessToken
                )
            }
            
            let result = Question(
                id: response.questionId,
                content: response.content,
                publishedDate: .now,
                isAnswered: response.isAnswered,
                isLived: response.questionStatus == "LIVE"
            )
            
            return result
        }
    )
    
    static let previewValue = Self(
        fetchQuestionList: { threshold in
            (stubQuestionList, 25, QappleAPI.PaginationInfo(threshold: "", hasNext: false))
        },
        fetchMainQuestion: {
            Question(
                id: 0,
                content: "프리뷰용 테스트 질문입니다.",
                publishedDate: .now,
                isAnswered: false,
                isLived: true
            )
        }
    )
}

// MARK: - DependencyValues

extension DependencyValues {
    var questionRepository: QuestionRepository {
        get { self[QuestionRepository.self] }
        set { self[QuestionRepository.self] = newValue }
    }
}

// MARK: - Stub

extension QuestionRepository {
    
    private static var stubQuestionList: [Question] {
        var questionList: [Question] = []
        for i in 0..<25 {
            questionList.append(
                Question(
                    id: i,
                    content: "테스트 질문 \(i)",
                    publishedDate: .init(timeIntervalSinceNow: TimeInterval(i*(-10000))),
                    isAnswered: i % 2 == 1,
                    isLived: i == 0
                )
            )
        }
        return questionList
    }
}
