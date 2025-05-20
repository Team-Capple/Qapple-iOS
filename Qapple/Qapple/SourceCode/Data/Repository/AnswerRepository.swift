//
//  AnswerRepository.swift
//  Qapple
//
//  Created by 김민준 on 1/23/25.
//

import ComposableArchitecture
import QappleRepository
import Foundation

struct AnswerRepository {
    var fetchAnswerListOfProfile: (_ threshold: Int?) async throws -> ([Answer], QappleAPI.PaginationInfo)
    var fetchAnswerPreviewList: (_ questionId: Int) async throws -> [Answer]
    var fetchAnswerListOfQuestion: (_ questionId: Int, _ threshold: Int?) async throws -> (
        [Answer],
        QappleAPI.TotalCount,
        QappleAPI.PaginationInfo
    )
    var postAnswer: (_ questionId: Int, _ answer: String) async throws -> Void
    var deleteAnswer: (_ answerId: Int) async throws -> Void
    var likeAnswer: (_ questionId: Int) async throws -> Void
}

// MARK: - DependencyKey

extension AnswerRepository: DependencyKey {
    
    static let liveValue = Self(
        fetchAnswerListOfProfile: { threshold in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await AnswerAPI.fetchListOfMine(
                    threshold: threshold,
                    pageSize: 30,
                    server: server,
                    accessToken: accessToken
                )
            }
            let answerList = response.content.map {
                Answer(
                    id: $0.answerId,
                    writerId: $0.writerId,
                    content: $0.content,
                    authorNickname: $0.nickname,
                    authorGeneration: $0.writerGeneration,
                    publishedDate: $0.writeAt.ISO8601ToDate(.yearMonthDateTimeMilliseconds),
                    isReported: false,
                    isMine: true,
                    isLiked: $0.isLiked,
                    isResignMember: false,
                    // TODO: 5/20 논의 필요
                    commentCount: 0,
                    heartCount: $0.heartCount
                )
            }
            let paginationInfo = QappleAPI.PaginationInfo(
                threshold: response.threshold,
                hasNext: response.hasNext
            )
            return (answerList, paginationInfo)
        },
        fetchAnswerPreviewList: { questionId in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await AnswerAPI.fetchListOfQuestion(
                    questionId: Int(questionId),
                    threshold: nil,
                    pageSize: 3,
                    server: server,
                    accessToken: accessToken
                )
            }
            return response.content.map {
                Answer(
                    id: $0.answerId,
                    writerId: $0.writerId,
                    content: $0.content,
                    authorNickname: $0.nickname,
                    authorGeneration: $0.writerGeneration,
                    publishedDate: $0.writeAt.ISO8601ToDate(.yearMonthDateTimeMilliseconds),
                    isReported: $0.isReported,
                    isMine: $0.isMine,
                    isLiked: $0.isLiked ?? false,
                    isResignMember: $0.nickname == "알 수 없음",
                    commentCount: $0.commentCount,
                    heartCount: $0.heartCount
                )
            }
        },
        fetchAnswerListOfQuestion: { questionId, threshold in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await AnswerAPI.fetchListOfQuestion(
                    questionId: Int(questionId),
                    // TODO: 5/20 수정 필요
                    threshold: threshold,
                    pageSize: 30,
                    server: server,
                    accessToken: accessToken
                )
            }
            let answerList = response.content.map {
                Answer(
                    id: $0.answerId,
                    writerId: $0.writerId,
                    content: $0.content,
                    authorNickname: $0.nickname,
                    authorGeneration: $0.writerGeneration,
                    publishedDate: $0.writeAt.ISO8601ToDate(.yearMonthDateTimeMilliseconds),
                    isReported: $0.isReported,
                    isMine: $0.isMine,
                    isLiked: $0.isLiked ?? false,
                    isResignMember: $0.nickname == "알 수 없음",
                    commentCount: $0.commentCount,
                    heartCount: $0.heartCount
                )
            }
            let paginationInfo = QappleAPI.PaginationInfo(
                threshold: response.threshold,
                hasNext: response.hasNext
            )
            return (answerList, response.total, paginationInfo)
        },
        postAnswer: { questionId, answer in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await AnswerAPI.create(
                    content: answer,
                    questionId: questionId,
                    server: server,
                    accessToken: accessToken
                )
            }
        },
        deleteAnswer: { answerId in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await AnswerAPI.delete(
                    answerId: answerId,
                    server: server,
                    accessToken: accessToken
                )
            }
        },
        likeAnswer: { answerId in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await AnswerAPI.like(
                    answerId: answerId,
                    server: server,
                    accessToken: accessToken
                )
            }
        }
    )
    
    static let previewValue = Self(
        fetchAnswerListOfProfile: { _ in
            let stubProfiles = (0..<10).map { i in
                Answer(
                    id: i,
                    writerId: i,
                    content: "테스트 답변 \(i)",
                    authorNickname: "시몬스",
                    authorGeneration: "3기",
                    publishedDate: .init(timeIntervalSinceNow: TimeInterval(i * -5000)),
                    isReported: false,
                    isMine: true,
                    isLiked: false,
                    isResignMember: false,
                    commentCount: 0,
                    heartCount: 0
                )
            }
            return (stubProfiles, .init(threshold: "10", hasNext: false))
        },
        fetchAnswerPreviewList: { questionId in
            stubAnswerList.dropLast(22)
        },
        fetchAnswerListOfQuestion: { _, _ in
            (stubAnswerList, 25, .init(threshold: "", hasNext: false))
        },
        postAnswer: { _, _ in },
        deleteAnswer: { _ in },
        likeAnswer: { _ in }
    )
}

// MARK: - DependencyValues

extension DependencyValues {
    var answerRepository: AnswerRepository {
        get { self[AnswerRepository.self] }
        set { self[AnswerRepository.self] = newValue }
    }
}

// MARK: - Stub

extension AnswerRepository {
    
    private static var stubAnswerList: [Answer] {
        var answerList: [Answer] = []
        for i in 0..<25 {
            answerList.append(
                Answer(
                    id: i,
                    writerId: i,
                    content: "테스트 답변 \(i)",
                    authorNickname: "\(i)번째 러너",
                    authorGeneration: "3기",
                    publishedDate: .init(timeIntervalSinceNow: TimeInterval(i*(-10000))),
                    isReported: i == 2,
                    isMine: i == 1,
                    isLiked: i == 4,
                    isResignMember: i == 3,
                    commentCount: i,
                    heartCount: i
                )
            )
        }
        return answerList
    }
}
