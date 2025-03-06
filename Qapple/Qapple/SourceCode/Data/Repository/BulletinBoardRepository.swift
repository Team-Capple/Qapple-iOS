//
//  BulletinBoardRepository.swift
//  Qapple
//
//  Created by Simmons on 1/23/25.
//

import Foundation
import ComposableArchitecture
import QappleRepository

struct BulletinBoardRepository {
    var fetchBulletinBoardList: (_ threshold: Int?) async throws -> ([BulletinBoard], QappleAPI.PaginationInfo)
    var postBoard: (_ content: String) async throws -> Void
    var fetchSingleBoard: (_ boardId: Int) async throws -> BulletinBoard
    var deleteBoard: (_ boardId: Int) async throws -> Void
    var likeBoard: (_ boardId: Int) async throws -> Void
    var searchBoard: (_ keyword: String?, _ threshold: Int?) async throws -> ([BulletinBoard], QappleAPI.PaginationInfo)
}

// MARK: - DependencyKey

extension BulletinBoardRepository: DependencyKey {
    
    static let liveValue = Self(
        fetchBulletinBoardList: { threshold in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await BoardAPI.fetchList(
                    threshold: threshold,
                    pageSize: 30,
                    server: server,
                    accessToken: accessToken
                )
            }
            let list = response.content.map {
                BulletinBoard(
                    id: $0.boardId,
                    writerId: $0.writerId,
                    writerNickname: $0.writerNickname,
                    writerGeneration: $0.writerGeneration,
                    content: $0.content,
                    heartCount: $0.heartCount,
                    commentCount: $0.commentCount,
                    createAt: $0.createdAt.ISO8601ToDate,
                    isMine: $0.isMine,
                    isReported: $0.isReported,
                    isLiked: $0.isLiked
                )
            }
            let paginationInfo = QappleAPI.PaginationInfo(
                threshold: response.threshold,
                hasNext: response.hasNext
            )
            return (list, paginationInfo)
        },
        postBoard: { content in
            let _ = try await RepositoryService.shared.request { server, accessToken in
                try await BoardAPI.create(
                    content: content,
                    boardType: .freeBoard,
                    server: server,
                    accessToken: accessToken
                )
            }
        },
        fetchSingleBoard: { boardId in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await BoardAPI.fetchSingle(
                    boardId: boardId,
                    server: server,
                    accessToken: accessToken
                )
            }
            return BulletinBoard(
                id: response.boardId,
                writerId: response.writerId,
                writerNickname: response.writerNickname,
                writerGeneration: response.writerGeneration,
                content: response.content,
                heartCount: response.heartCount,
                commentCount: response.commentCount,
                createAt: response.createdAt.ISO8601ToDate,
                isMine: response.isMine,
                isReported: response.isReported,
                isLiked: response.isLiked
            )
        },
        deleteBoard: { boardId in
            let _ = try await RepositoryService.shared.request { server, accessToken in
                try await BoardAPI.delete(
                    boardId: boardId,
                    server: server,
                    accessToken: accessToken
                )
            }
        },
        likeBoard: { boardId in
            let _ = try await RepositoryService.shared.request { server, accessToken in
                try await BoardAPI.like(
                    boardId: boardId,
                    server: server,
                    accessToken: accessToken
                )
            }
        },
        searchBoard: { keyword, threshold in
            let response = try await RepositoryService.shared.request { server, accessToken in
                try await BoardAPI.search(
                    keyword: keyword ?? "",
                    threshold: threshold,
                    pageSize: 30,
                    server: server,
                    accessToken: accessToken
                )
            }
            let list = response.content.map {
                BulletinBoard(
                    id: $0.boardId,
                    writerId: $0.writerId,
                    writerNickname: $0.writerNickname,
                    writerGeneration: $0.writerGeneration,
                    content: $0.content,
                    heartCount: $0.heartCount,
                    commentCount: $0.commentCount,
                    createAt: $0.createdAt.ISO8601ToDate,
                    isMine: $0.isMine,
                    isReported: $0.isReported,
                    isLiked: $0.isLiked
                )
            }
            let paginationInfo = QappleAPI.PaginationInfo(
                threshold: response.threshold,
                hasNext: response.hasNext
            )
            return (list, paginationInfo)
        }
    )
    
    static let previewValue = Self(
        fetchBulletinBoardList: { threshold in
            (stubBulletinBoardList, QappleAPI.PaginationInfo(threshold: "0", hasNext: false))
        },
        postBoard: { content in
            print("게시글이 성공적으로 등록되었습니다: \(content)")
        },
        fetchSingleBoard: { boardId in
            stubBulletinBoardList.first { $0.id == boardId } ?? stubBulletinBoardList[0]
        },
        deleteBoard: { boardId in
            print("게시글이 성공적으로 삭제되었습니다: \(boardId)")
        },
        likeBoard: { boardId in
            print("게시글에 좋아요를 눌렀습니다: \(boardId)")
        },
        searchBoard: { keyword, threshold in
            let filteredList = stubBulletinBoardList.filter { $0.content.contains(keyword ?? "") }
            return (filteredList, QappleAPI.PaginationInfo(threshold: "0", hasNext: false))
        }
    )
    
    static let testValue = Self(
        fetchBulletinBoardList: { _ in
            (stubBulletinBoardList, .init(threshold: "0", hasNext: false))
        },
        postBoard: { _ in },
        fetchSingleBoard: { _ in stubSingleBulletinBoard },
        deleteBoard: { _ in },
        likeBoard: { _ in },
        searchBoard: { _, _ in
            (stubBulletinBoardList, .init(threshold: "0", hasNext: false))
        }
    )
}

// MARK: - DependencyValues

extension DependencyValues {
    var bulletinBoardRepository: BulletinBoardRepository {
        get { self[BulletinBoardRepository.self] }
        set { self[BulletinBoardRepository.self] = newValue }
    }
}

// MARK: - Stub

extension BulletinBoardRepository {
    
    private static var stubBulletinBoardList: [BulletinBoard] {
        var boardList: [BulletinBoard] = []
        for i in 0..<10 {
            boardList.append(
                BulletinBoard(
                    id: i,
                    writerId: i,
                    writerNickname: "사용자 \(i)",
                    writerGeneration: "3기",
                    content: "테스트 게시글 내용 \(i)",
                    heartCount: i * 2,
                    commentCount: i,
                    createAt: .init(timeIntervalSinceNow: TimeInterval(i * -5000)),
                    isMine: i % 2 == 0,
                    isReported: false,
                    isLiked: i % 3 == 0
                )
            )
        }
        return boardList
    }
    
    private static let stubSingleBulletinBoard: BulletinBoard =
        .init(
            id: 1,
            writerId: 1,
            writerNickname: "테스트",
            content: "테스트입니다.",
            heartCount: 2,
            commentCount: 3,
            createAt: Date.distantPast,
            isMine: true,
            isReported: false,
            isLiked: false
        )
}
