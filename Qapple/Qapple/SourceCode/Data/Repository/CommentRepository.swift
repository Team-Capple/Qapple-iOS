//
//  CommentRepository.swift
//  Qapple
//
//  Created by 문인범 on 1/23/25.
//

import Foundation
import QappleRepository
import ComposableArchitecture


/**
 Comment API 의존성
 */
struct CommentRepository {
    var fetchBoardCommentList: (_ boardId: Int, _ threshold: Int?) async throws -> ([BoardComment], QappleAPI.PaginationInfo)
    var deleteBoardComment: (_ boardCommentId: Int) async throws -> Void
    var postBoardComment: (_ boardId: Int, _ content: String) async throws -> Void
    var likeBoardComment: (_ boardCommentId: Int) async throws -> Void
}


// MARK: - DependencyKey
extension CommentRepository: DependencyKey {
    
    static let liveValue: CommentRepository = Self(
        fetchBoardCommentList: { boardId, threshold in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await BoardCommentAPI.fetchList(
                    boardId: boardId,
                    threshold: threshold,
                    pageSize: 25,
                    server: server,
                    accessToken: accessToken
                )
            }
            let list = response.content.map {
                BoardComment(
                    id: $0.boardCommentId,
                    writeId: $0.writerId,
                    content: $0.content,
                    heartCount: $0.heartCount,
                    isLiked: $0.isLiked,
                    isMine: $0.isMine,
                    isReport: $0.isReport,
                    createdAt: $0.createdAt.ISO8601ToDate,
                    anonymityId: -2
                )
            }
            let paginationInfo = QappleAPI.PaginationInfo(
                threshold: response.threshold,
                hasNext: response.hasNext
            )
            return (list, paginationInfo)
        },
        deleteBoardComment: { boardCommentId in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await BoardCommentAPI.delete(
                    commentId: boardCommentId,
                    server: server,
                    accessToken: accessToken
                )
            }
        },
        postBoardComment: { boardId, content in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await BoardCommentAPI.create(
                    boardId: boardId,
                    content: content,
                    server: server,
                    accessToken: accessToken
                )
            }
        },
        likeBoardComment: { boardCommentId in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await BoardCommentAPI.like(
                    commentId: boardCommentId,
                    server: server,
                    accessToken: accessToken
                )
            }
        }
    )
    
    static let previewValue: CommentRepository = Self(
        fetchBoardCommentList: { _, _ in
            (sampleCommentList, .init(threshold: "", hasNext: false))
        },
        deleteBoardComment: { boardCommentId in
                print("\(boardCommentId) 댓글을 삭제했습니다.")
        },
        postBoardComment: { boardId, content in
                print("\(boardId) 게시글에 \(content)글을 작성했습니다.")
        },
        likeBoardComment: { commentId in
            print("게시글에 좋아요를 눌렀습니다: \(commentId)")
        }
    )
    
    static let testValue: CommentRepository = Self(
        fetchBoardCommentList: { _, _ in
            (CommentRepository.sampleCommentList, CommentRepository.samplePaginationInfo)
        },
        deleteBoardComment: { _ in },
        postBoardComment: { _, _ in },
        likeBoardComment: { _ in }
    )
}


// MARK: - DependencyValues
extension DependencyValues {
    var commentRepository: CommentRepository {
        get { self[CommentRepository.self] }
        set { self[CommentRepository.self] = newValue }
    }
}


// MARK: - TestValues
extension CommentRepository {
    private static let sampleCommentList: [BoardComment] = [
        .init(
            id: 1,
            writeId: 1,
            content: "테스트 댓글입니다.",
            heartCount: 3,
            isLiked: true,
            isMine: true,
            isReport: false,
            createdAt: .now
        ),
        .init(
            id: 2,
            writeId: 2,
            content: "테스트 댓글입니다.2",
            heartCount: 4,
            isLiked: false,
            isMine: false,
            isReport: true,
            createdAt: Date().addingTimeInterval(-30)
        ),
        .init(
            id: 3,
            writeId: 3,
            content: "테스트 댓글입니다.3",
            heartCount: 0,
            isLiked: true,
            isMine: false,
            isReport: false,
            createdAt: Date().addingTimeInterval(-60*20)
        ),
        .init(
            id: 4,
            writeId: 2,
            content: "테스트 댓글입니다.4",
            heartCount: 23,
            isLiked: false,
            isMine: false,
            isReport: false,
            createdAt: Date().addingTimeInterval(-60*60*2)
        )
    ]
    
    private static let samplePaginationInfo = QappleAPI.PaginationInfo(threshold: "1234", hasNext: false)
}
