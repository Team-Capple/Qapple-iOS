//
//  AnswerCommentRepository.swift
//  Qapple
//
//  Created by 문인범 on 5/20/25.
//

import ComposableArchitecture
import QappleRepository
import Foundation


/**
 AnswerComment API 의존성
 */
struct AnswerCommentRepository {
    var fetchAnswerComments: (_ answerId: Int) async throws -> [AnswerComment]
    var createAnswerComment: (_ answerId: Int, _ content: String) async throws -> Void
    var likeAnswerComment: (_ answerCommentId: Int) async throws -> Void
    var deleteAnswerComment: (_ answerCommentId: Int) async throws -> Void
}


// MARK: - DependencyKey
extension AnswerCommentRepository: DependencyKey {
    static let liveValue: AnswerCommentRepository = Self(
        fetchAnswerComments: { answerId in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await AnswerCommentAPI.fetchAnswerComments(
                    answerId: answerId,
                    server: server,
                    accessToken: accessToken
                )
            }
            
            let list = response.answerCommentInfos.map {
                AnswerComment(
                    id: $0.answerCommentId,
                    writeId: $0.writerId,
                    // TODO: 5/20 문의 필요(writer generation, isLiked, isMine, isReport이 있는지 여부)
                    writerGeneration: "",
                    content: $0.content,
                    heartCount: $0.heartCount,
                    isLiked: false,
                    isMine: false,
                    isReport: false,
                    createdAt: $0.createdAt.ISO8601ToDate(.yearMonthDateTimeMilliseconds),
                    anonymityId: -2
                )
            }
            
            // TODO: 추후 신고된 아이디 로직 수정 필요
            return list.filter { !UserDefaultsService.reportedAnswerCommentIds.contains($0.id) }
        },
        createAnswerComment: { answerId, content in
            let _ = try await RepositoryService.shared.request { server, accessToken in
                try await AnswerCommentAPI.createAnswerComment(
                    answerId: answerId,
                    content: content,
                    server: server,
                    accessToken: accessToken
                )
            }
        },
        likeAnswerComment: { answerCommentId in
            let _ = try await RepositoryService.shared.request { server, accessToken in
                try await AnswerCommentAPI.likeAnswerComment(
                    answerCommentId: answerCommentId,
                    server: server,
                    accessToken: accessToken
                )
            }
        },
        deleteAnswerComment: { answerCommentId in
            let _ = try await RepositoryService.shared.request { server, accessToken in
                try await AnswerCommentAPI.deleteAnswerComment(
                    answerCommentId: answerCommentId,
                    server: server,
                    accessToken: accessToken
                )
            }
        }
    )
    
    static let previewValue: AnswerCommentRepository = .init(
        fetchAnswerComments: { _ in
            sampleComments
        },
        createAnswerComment: { answerId, content in
            print("\(answerId) 게시글에 \"\(content)\" 댓글을 작성했습니다.")
        },
        likeAnswerComment: { answerCommentId in
            print("\(answerCommentId) 댓글에 좋아요를 눌렀습니다.")
        },
        deleteAnswerComment: { answerCommentId in
            print("\(answerCommentId) 댓글을 삭제했습니다.")
        }
    )
    
    static let testValue: AnswerCommentRepository = .init(
        fetchAnswerComments: { _ in
            sampleComments
        },
        createAnswerComment: { _, _ in },
        likeAnswerComment: { _ in },
        deleteAnswerComment: { _ in }
    )
}


// MARK: DependencyValues
extension DependencyValues {
    var answerCommentRepository: AnswerCommentRepository {
        get { self[AnswerCommentRepository.self] }
        set { self[AnswerCommentRepository.self] = newValue }
    }
}


// MARK: Test Values
extension AnswerCommentRepository {
    private static let sampleComments: [AnswerComment] = {
        var result = [AnswerComment]()
        for i in 1...10 {
            result.append(
                AnswerComment(
                    id: i,
                    writeId: i,
                    writerGeneration: "4기",
                    content: "테스트 댓글\(i)",
                    heartCount: i,
                    isLiked: i == 1,
                    isMine: i == 2,
                    isReport: i == 3,
                    createdAt: .now,
                    anonymityId: -2
                )
            )
        }
        return result
    }()
}
